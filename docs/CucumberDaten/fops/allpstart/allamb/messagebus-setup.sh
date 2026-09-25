#! /bin/sh

# only for internal use in project management !
# handle required components for database triggering via abas message bus

MYVER="1.0.3"

CURRENTDIR=`pwd`
# TODO: read setup values (rmq host, port, manageport, user, pass, ...)
MYPATH=`dirname $0`
MYPROG=`basename $0`
#echo $MYPATH
cd $MYPATH
MYPATH=`pwd`

# download python script from rabbit
#echo "curl -o $MANDANTDIR/allpstart/rmqadmin_${HOSTNAME}_${MNAME} http://${rmq_host}:${rmq_manageport}/cli/rabbitmqadmin"
#curl -o $MANDANTDIR/allpstart/rmqadmin_${HOSTNAME}_${MNAME} http://${rmq_host}:${rmq_manageport}/cli/rabbitmqadmin

# NOTE: rabbit interaction is done via "rabbitmqadmin" which requires python (2.6 or higher) !

# rabbitmqadmin can cause some trouble -> using curl & http api
RMQ_USE_CURL="1"


# default values
RMQ_USER_DEF="guest"
RMQ_PASS_DEF="guest"
RMQ_HOST_DEF="${HOSTNAME}"
RMQ_PORT_DEF=5672
RMQ_MANAGEPORT_DEF=15672
RMQ_VHOST_DEF="${HOSTNAME}_${MNAME}"
ICE_CLIENTDIR_DEF="${MANDANTDIR}"
ICE_SETUPQUEUE_DEF="handshake"
ICE_DATADIR_DEF=""

# daemon main class full qualified --> used to detect running processes
ICE_MAIN_FQ="de.abas.ice.daemon.Main"
# path to binary
# TODO: switch to official version in abas V2016r4n03 !!
#ICE_DAEMONPATH=${MANDANTDIR}/${MYPATH}/icedaemon-1.0.2-SNAPSHOT/bin
#ICE_DAEMONPATH=${MANDANTDIR}/${MYPATH}/icedaemon-1.0.2-SNAPSHOT/bin
ICE_DAEMONPATH=${HOMEDIR}/incrementalExport/daemon/bin
ICE_DAEMON_BIN=icedaemon
ICE_DAEMON_SCRIPT=icedaemon-service

FN_CONF="messagebus.conf"

ICE_PARAMS=""
ICE_PARAMS_CHECK=""

myexit() {
  cd $CURRENTDIR
  
  exit $1
}

usage() {  
  echo "usage: ${MYPROG} -a <action> [options]"
  echo "          -a <action>:  checkall"
  echo "                        existsVhost"
  echo "                        declareVhost"
  echo "                        declarePermission"
  echo "                        checkDaemon"
  echo "                        isDaemonRunning"
  echo ""
  echo "     options:"
  echo "          -u <RMQ user> (default: ${RMQ_USER_DEF})"
  echo "          -p <RMQ password> (default: ${RMQ_PASS_DEF})"
  echo "          -s <RMQ host> (default: \"<hostname>\")"
  echo "          -t <RMQ port> (default: ${RMQ_PORT_DEF})"
  echo "          -m <RMQ management port> (default: ${RMQ_MANAGEPORT_DEF})"
  echo "          -v <RMQ vhost> (default: \"<hostname>_MNAME\")"
  echo "          -e <icedaemon client dir> (default: MANDANTDIR)"
  echo "          -f <datadir> (default: java.io.tmpdir)"
  echo "          -q <icedaemon setup queue> (default: handshake)"
  echo "          -c read variables from config file (messagebus.conf)"
  echo ""
  echo "   examples: \"${MYPROG} -a existsVhost -v myvhost\""
  echo "                    -> will return 0 if the given vhost exists"
  echo "             \"${MYPROG} -c -a checkall\""
  echo "                    -> read variables from config file (messagebus.conf)"
  echo "                    -> check if virtual host exists (will declare vhost & set permissions if required)"
  echo "                    -> check daemon process (will start a new daemon process if required)"
  echo ""
  myexit 1
}


replaceWildcards() {
  MYHN=`hostname`
  MYVAR=`echo "${1}" | sed "s/%ERP_HOST%/${MYHN}/g"`
  
  MYVAR=`echo "${MYVAR}" | sed "s/%MNAME%/${MNAME}/g"`
  
  #echo "my   $MYVAR"
  
  echo ${MYVAR}
}

updateIceParams() {  
  ICE_PARAMS=""
  ICE_PARAMS_CHECK=""
  if [ ! "${RMQ_USER}" = "${RMQ_USER_DEF}" ] ; then
    ICE_PARAMS="${ICE_PARAMS} -u ${RMQ_USER}"
    ICE_PARAMS_CHECK="${ICE_PARAMS_CHECK} | grep '${ICE_MAIN_FQ}.*-u ${RMQ_USER}'"
  fi
  if [ ! "${RMQ_PASS}" = "${RMQ_PASS_DEF}" ] ; then  
    ICE_PARAMS="${ICE_PARAMS} -p ${RMQ_PASS}"
    ICE_PARAMS_CHECK="${ICE_PARAMS_CHECK} | grep '${ICE_MAIN_FQ}.*-p ${RMQ_PASS}'"
  fi
  if [ ! "${ICE_SETUPQUEUE}" = "${ICE_SETUPQUEUE_DEF}" ] ; then
    ICE_PARAMS="${ICE_PARAMS} -m ${ICE_SETUPQUEUE}"
    ICE_PARAMS_CHECK="${ICE_PARAMS_CHECK} | grep '${ICE_MAIN_FQ}.*-m ${ICE_SETUPQUEUE}'"
  fi
  if [ ! "${ICE_DATADIR}" = "${ICE_DATADIR_DEF}" ] ; then
    ICE_PARAMS="${ICE_PARAMS} -f ${ICE_DATADIR}"
    #echo "datadir  $ICE_DATADIR"
  fi
}

readConfigFile() {  
  MYCONF="${1}"
  if [ -z "$1" ] ; then
    MYCONF="${FN_CONF}"
    #echo "empty"
  fi
  
  MYCONF2=`pwd`"/${MYCONF}"
  
  if [ -f "$MYCONF2" ] ; then

    MYCONF=$MYCONF2
  fi

  . ${MYCONF} 
  MYSTATE=$?
  
  if [ "$MYSTATE" -gt 0 ] ; then
    echo "could not read config file: ${MYCONF}"
    myexit $MYSTATE
  else  
    updateIceParams
  fi
}

setType() {
  if [ -z "$1" ] ; then
    echo "argument required: type is \"curl\" or \"rabbitmqadmin\""
    return 1
  fi

  if [ "$1" = "rabbitmqadmin" ] ; then
    RMQ_USE_CURL="0"
  else
    RMQ_USE_CURL="1"
  fi  
}

updateProperties() {
  if [ -z "$1" ] ; then
    echo "argument required: target file (absolute path)"
    return 1
  fi
  
  MYTMP="${MANDANTDIR}/rmtmp/mb."`date "+%s"`
  echo "" > $MYTMP
  
  while read line
  do
    MYTMP2=`echo $line | grep "^#"`
    if [ $? -eq 0 ] ; then
      # keep comment lines
      echo "$line" >> $MYTMP
    else
      eval echo "$line" >> $MYTMP
    fi
    
  done < "${FN_CONF}"
  
  if [ -f "${1}" ] ; then
    diff -q "${1}" ${MYTMP}
    if [ "${?}" -gt 0 ] ; then
      cp -f ${MYTMP} "${1}"
    fi
  else
    cp -f ${MYTMP} "${1}"
  fi
  
  myexit 0
}

existsVhost() {
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
  #echo `pwd`  
  #echo "ex vh  ./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} -f bash list vhosts"
  MYVHOSTS=`./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} -f bash list vhosts`
  
  for vhost in  $MYVHOSTS; do 
    #echo "vhost:  "$vhost
    if [ "$vhost" = "$1" ] ; then 
      echo "vhost exists:  ${vhost}"
      return 0
    fi
  done

  # not found
  return 1
}

declareVhost() {
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
  
  #MYVHOSTS=`allpstart/amb/rabbitmqadmin -f bash list vhosts`
  ./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} declare vhost name=$1
  STATUS=$?  
  
  return $STATUS
}

declarePermission() {
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
  if [ -z "$2" ] ; then
    echo "argument required: user"
    return 1
  fi
  
  #MYVHOSTS=`allpstart/amb/rabbitmqadmin -f bash list vhosts`
  #./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} declare permission vhost=${RMQ_VHOST} user=${RMQ_USER} configure=.* read=.* write=.*
  ./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} declare permission vhost=${1} user=${2} configure=.* read=.* write=.*
  STATUS=$?
  
  return $STATUS
}

# e.g. $1=vhosts, $2=ice
# $1 url entry after ".../api/"
# $2 name of the property
rabbitPropertyExistsCurl() { 
  
  unset MYTEST  
  MYTEST=`curl -i -u ${RMQ_USER}:${RMQ_PASS} http://${RMQ_HOST}:${RMQ_MANAGEPORT}/api/${1} | grep "\"name\":\"${2}\""`

  if [ "${MYTEST}" = "" ] ; then
    return 1
  else
    return 0
  fi
}

checkRabbitCurl() {
  
  UNKNOWN_USER=20
  UNKNOWN_VHOST=10
  
  # user exists?
  if ! rabbitPropertyExistsCurl "users" ${RMQ_USER} ; then
    echo "User does not exist! :  ${RMQ_USER}"
    return $UNKNOWN_USER
  fi
  # vhost exists?
  if ! rabbitPropertyExistsCurl "vhosts" ${RMQ_VHOST} ; then
    echo "VHost does not exist! :  ${RMQ_VHOST}"
    return $UNKNOWN_VHOST
  fi
}

existsVhostCurl() {
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
  
  rabbitPropertyExistsCurl "vhosts" ${1}
  return $?
}

declareVhostCurl() { 
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
   
  
  curl -i -u ${RMQ_USER}:${RMQ_PASS} -H "content-type:application/json" -XPUT http://${RMQ_HOST}:${RMQ_MANAGEPORT}/api/vhosts/${1}

  return $?
}

declarePermissionCurl() {
  if [ -z "$1" ] ; then
    echo "argument required: vhost"
    return 1
  fi
  if [ -z "$2" ] ; then
    echo "argument required: user"
    return 1
  fi
  curl -i -u ${RMQ_USER}:${RMQ_PASS} -H "content-type:application/json" -XPUT -d'{"configure":".*","write":".*","read":".*"}' http://${RMQ_HOST}:${RMQ_MANAGEPORT}/api/permissions/${1}/${2}
  
  return $?
}

showOverviewJson() {
  ./rabbitmqadmin -H ${RMQ_HOST} -P ${RMQ_MANAGEPORT} -u ${RMQ_USER} -p ${RMQ_PASS} -V ${RMQ_VHOST} show overview -f pretty_json
  return $?
}

isDaemonRunning() {

  if [ -e ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} ] ; then
    ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} -a status
    return $?
  else

    ICEDCMD="ps -ef | grep \"${ICE_MAIN_FQ}.*-e ${ICE_CLIENTDIR}\" | grep \"${ICE_MAIN_FQ}.*-s ${RMQ_HOST}\" | grep \"${ICE_MAIN_FQ}.*-v ${RMQ_VHOST}\" ${ICE_PARAMS_CHECK} | grep -v grep"
    ICEDPROC=`eval $ICEDCMD`

    #echo icedproc $ICEDPROC
    # echo ""
    # echo ""  
    
    if [ "${RMQ_HOST}" = "${HOSTNAME}" ] ; then
      # additionally check for process with option "-s localhost"
      ICEDCMD="ps -ef | grep \"${ICE_MAIN_FQ}.*-e ${ICE_CLIENTDIR}\" | grep \"${ICE_MAIN_FQ}.*-s localhost\" | grep \"${ICE_MAIN_FQ}.*-v ${RMQ_VHOST}\" ${ICE_PARAMS_CHECK} | grep -v grep"
      
      ICEDPROC_LH=`eval $ICEDCMD`
      # if [ ! -z "$ICEDPROC_LH" ] ; then
        # echo "process running for \"localhost\""
        # if [ ! -z "$ICEDPROC" ] ; then
          # echo "multiple processes !!"
        # fi
      # fi
    fi

    if [ ! -z "${ICEDPROC}" ] ; then
       return 0
    fi
    if [ ! -z "${ICEDPROC_LH}" ] ; then
       return 0
    fi
    
  fi
  
  return 1
}

getDaemonPid() {

  ICEDCMD="ps -ef | grep \"${ICE_MAIN_FQ}.*-e ${ICE_CLIENTDIR}\" | grep \"${ICE_MAIN_FQ}.*-s ${RMQ_HOST}\" | grep \"${ICE_MAIN_FQ}.*-v ${RMQ_VHOST}\" ${ICE_PARAMS_CHECK} | grep -v grep"
  ICEDPROC=`eval $ICEDCMD`

	#echo icedproc $ICEDPROC
  # echo ""
  # echo ""  
  
  if [ "${RMQ_HOST}" = "${HOSTNAME}" ] ; then
    # additionally check for process with option "-s localhost"
    ICEDCMD="ps -ef | grep \"${ICE_MAIN_FQ}.*-e ${ICE_CLIENTDIR}\" | grep \"${ICE_MAIN_FQ}.*-s localhost\" | grep \"${ICE_MAIN_FQ}.*-v ${RMQ_VHOST}\" ${ICE_PARAMS_CHECK} | grep -v grep"
    
    ICEDPROC_LH=`eval $ICEDCMD`
    # if [ ! -z "$ICEDPROC_LH" ] ; then
      # echo "process running for \"localhost\""
      # if [ ! -z "$ICEDPROC" ] ; then
        # echo "multiple processes !!"
      # fi
    # fi
  fi

  if [ ! -z "${ICEDPROC}" ] ; then
    set -- ${ICEDPROC}
    echo $2
    return 0
  fi
  if [ ! -z "${ICEDPROC_LH}" ] ; then
    set -- ${ICEDPROC_LH}
    echo $2
    eturn 0
  fi
  
  echo "-1"
  return 1
}

shutdownDaemon() {

  if [ -e ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} ] ; then
    ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} -a stop
  else
    ICEPID=""
    ICEPID=`getDaemonPid`
    if [ "${ICEPID}" -gt 0 ] ; then
      kill -15 ${ICEPID}
      #echo "1 .. kill pid ${ICEPID}"
      sleep 2
    fi
    ICEPID=`getDaemonPid`
    if [ "${ICEPID}" -gt 0 ] ; then
      kill -2 ${ICEPID}
      #echo "2 .. kill pid ${ICEPID}"
      sleep 2
    else
      return 0
    fi
    ICEPID=`getDaemonPid`
    if [ "${ICEPID}" -gt 0 ] ; then
      kill -1 ${ICEPID}
      #echo "3 .. kill pid ${ICEPID}"
      sleep 2
    else
      return 0
    fi
    ICEPID=`getDaemonPid`
    if [ "${ICEPID}" -gt 0 ] ; then
      kill -9 ${ICEPID}
     # echo "4 .. kill pid ${ICEPID}"
      sleep 2
    else
      return 0
    fi  
    ICEPID=`getDaemonPid`
    if [ "${ICEPID}" -gt 0 ] ; then
    #echo "5 .. kill pid ${ICEPID} failed !!"
      return 1
    else
      return 0
    fi
  fi
}

startDaemon() {
  if [ -e ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} ] ; then
    echo ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} -a start -s ${RMQ_HOST} -v ${RMQ_VHOST} -e ${ICE_CLIENTDIR} ${ICE_PARAMS}
    ${ICE_DAEMONPATH}/${ICE_DAEMON_SCRIPT} -a start -s ${RMQ_HOST} -v ${RMQ_VHOST} -e ${ICE_CLIENTDIR} ${ICE_PARAMS}
  else
    echo "################################"
    echo "      starting daemon for -s $RMQ_HOST -v $RMQ_VHOST -e $ICE_CLIENTDIR ${ICE_PARAMS}"
    echo "################################"
    ${ICE_DAEMONPATH}/${ICE_DAEMON_BIN} -s ${RMQ_HOST} -v ${RMQ_VHOST} -e ${ICE_CLIENTDIR} ${ICE_PARAMS} &
    
    return $?
  fi
}

checkAndStartDaemon() {
  if ! isDaemonRunning ; then
    startDaemon
  else
    return 0
  fi
  
  isDaemonRunning
  return $?
}

setRmqUser() {  
  if [ ! -z $1 ] ; then    
    #echo "set user " $1
    RMQ_USER=$1    
  fi
}

setRmqPass() {  
  if [ ! -z $1 ] ; then    
    #echo "set user " $1
    RMQ_PASS=$1    
  fi
}



# Parameter auswerten
OPTSTR="u:p:s:r:m:v:a:e:t:q:j:c"
non_opt_args="c"
non_opt_index=0

if [ "$1" = "start" -o "$1" = "stop" -o "$1" = "status" ] ; then
  MYACTION="ignore"
fi

if [ "$1" = "--help" ] ; then
  usage
fi

if [ "$1" = "--version" ] ; then
  echo "${MYVER}"
  myexit 0
fi

while [ $OPTIND -le $# ]
  do
      while getopts "$OPTSTR" arg
      do
        case $arg in
          u) setRmqUser $OPTARG  ;;
          p) setRmqPass $OPTARG  ;;
          s) RMQ_HOST=$OPTARG  ;;
          t) RMQ_PORT=$OPTARG  ;;
          m) RMQ_MANAGEPORT=$OPTARG  ;;
          v) RMQ_VHOST=$OPTARG  ;;
          q) ICE_SETUPQUEUE=$OPTARG  ;;
          a) MYACTION=$OPTARG  ;;
          e) ICE_CLIENTDIR=$OPTARG  ;;
          f) ICE_DATADIR=$OPTARG  ;;
     #     c) readConfigFile $OPTARG  ;;
          c) readConfigFile ""  ;;
          t) setType $OPTARG  ;;
          j) updateProperties $OPTARG  ;;
          *) echo "fehlerhafte Option / incorrect option"
             usage ;;     # fehlerhafte Option
        esac
      done

      # Jetzt steht OPTIND entweder auf einem Argument, das keine Option ist, oder
      # auf $# + 1
      eval akt_arg='"${'$OPTIND'}"'
      # leere Argumente interessieren nicht
      if [ -n "$akt_arg" ]
      then
          non_opt_args[$non_opt_index]="$akt_arg"
          non_opt_index=`expr $non_opt_index '+' 1`
      fi
      # Wenn nur noch 1 Argument uebrig ist, dann kann man aufhoeren (es ist ja
      # bereits in non_opt_args).
      if [ $# -eq 1 -o $OPTIND -ge $# ]
      then
          break
      fi
      # $* am ersten Argument hinter akt_arg beginnen lassen
      shift $OPTIND
      OPTIND=1
done

if [ -z ${MYACTION} ] ; then
  echo "action is not defined!"
  myexit 1
fi
if [ -z ${RMQ_USER} ] ; then
  RMQ_USER="${RMQ_USER_DEF}"
fi
if [ -z ${RMQ_PASS} ] ; then
  RMQ_PASS="${RMQ_PASS_DEF}"
fi
if [ -z ${RMQ_HOST} ] ; then
  RMQ_HOST="${RMQ_HOST_DEF}"
fi
if [ -z ${RMQ_PORT} ] ; then
  RMQ_PORT="${RMQ_PORT_DEF}"
fi
if [ -z ${RMQ_MANAGEPORT} ] ; then
  RMQ_MANAGEPORT="${RMQ_MANAGEPORT_DEF}"
fi
if [ -z ${RMQ_VHOST} ] ; then
  RMQ_VHOST="${RMQ_VHOST_DEF}"
fi
if [ -z ${ICE_CLIENTDIR} ] ; then
  ICE_CLIENTDIR="${ICE_CLIENTDIR_DEF}"
fi
if [ -z ${ICE_SETUPQUEUE} ] ; then
  ICE_SETUPQUEUE="${ICE_SETUPQUEUE_DEF}"
fi
#MYT1="%ERP_HOST%_%MNAME%"
#MYTEST=`replaceWildcards ${MYT1}`
#echo $MYACTION    $MYTEST

updateIceParams

# echo "host is "${RMQ_HOST}
  # echo "user $RMQ_USER"  
  # echo "pass $RMQ_PASS"  
  # echo "host $RMQ_HOST"  
  # echo "port $RMQ_PORT"  
  # echo "hp ${RMQ_HOST}:${RMQ_PORT}"  
  # echo "vhost $RMQ_VHOST"  

if [ "$1" = "start" ] ; then
  readConfigFile
  startDaemon
  isDaemonRunning
  exit $?
fi

if [ "$1" = "status" ] ; then
  readConfigFile
  isDaemonRunning
  exit $?
fi

if [ "$1" = "stop" ] ; then
  readConfigFile
  shutdownDaemon
  isDaemonRunning
  exit $?
fi 
  
  
###### actions  ################
##### Rabbit MQ  #############
if [ "${RMQ_USE_CURL}" = "1" ] ; then
  # use curl and http api
  if [ "${MYACTION}" = "checkall" ] ; then
    if ! existsVhostCurl $RMQ_VHOST ; then
      #echo "vhost does not exist $rmq_vhost"
      declareVhostCurl $RMQ_VHOST
      declarePermissionCurl $RMQ_VHOST $RMQ_USER
    fi
    existsVhostCurl $RMQ_VHOST
    STATUS=$?
    if [ "${STATUS}" -gt 0 ] ; then
      echo "vhost not found"
      myexit $STATUS
    fi
    checkAndStartDaemon
    isDaemonRunning
    STATUS=$?
    
    myexit $STATUS
  elif [ "${MYACTION}" = "checkRabbitMQ" ] ; then
    if ! existsVhostCurl $RMQ_VHOST ; then
      #echo "vhost does not exist $rmq_vhost"
      declareVhostCurl $RMQ_VHOST
      declarePermissionCurl $RMQ_VHOST $RMQ_USER
    else      
      myexit 0
    fi
    existsVhostCurl $RMQ_VHOST
    STATUS=$?    
    myexit $STATUS   
  elif [ "${MYACTION}" = "startDaemon" ] ; then
    checkAndStartDaemon
    myexit $?      
  elif [ "${MYACTION}" = "existsVhost" ] ; then
    existsVhostCurl $RMQ_VHOST
    myexit $?

  elif [ "${MYACTION}" = "declareVhost" ] ; then
    declareVhostCurl $RMQ_VHOST
    myexit $?

  elif [ "${MYACTION}" = "declarePermission" ] ; then
    declarePermissionCurl $RMQ_VHOST $RMQ_USER
    myexit $?
  elif [ "${MYACTION}" = "getDaemonPid" ] ; then
    getDaemonPid
    myexit $?
  elif [ "${MYACTION}" = "shutdownDaemon" ] ; then
    shutdownDaemon
    myexit $?
  fi
else
  # use rabbitmqadmin
  if [ "${MYACTION}" = "checkall" ] ; then
    if ! existsVhost $RMQ_VHOST ; then
      #echo "vhost does not exist $rmq_vhost"
      declareVhost $RMQ_VHOST
      declarePermission $RMQ_VHOST $RMQ_USER
    fi
    existsVhost $RMQ_VHOST
    STATUS=$?
    if [ "${STATUS}" -gt 0 ] ; then
      myexit $STATUS
    fi
    checkAndStartDaemon
    isDaemonRunning
    STATUS=$?
    
    myexit $STATUS
    
  elif [ "${MYACTION}" = "showOverview" ] ; then  
    showOverviewJson
    myexit $?
  elif [ "${MYACTION}" = "existsVhost" ] ; then
    existsVhost $RMQ_VHOST
    myexit $?

  elif [ "${MYACTION}" = "declareVhost" ] ; then
    declareVhost $RMQ_VHOST
    myexit $?

  elif [ "${MYACTION}" = "declarePermission" ] ; then
    declarePermission $RMQ_VHOST $RMQ_USER
    myexit $?
  fi
fi  
    
##### ice daemon  ####################
if [ "${MYACTION}" = "checkDaemon" ] ; then
  checkAndStartDaemon
  myexit $?

elif [ "${MYACTION}" = "isDaemonRunning" ] ; then
  isDaemonRunning
  myexit $?
else  
  echo "unknown action:  ${MYACTION}"
  myexit 1
fi

myexit 1

