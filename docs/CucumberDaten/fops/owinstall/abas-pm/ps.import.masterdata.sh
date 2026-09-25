#! /bin/sh

usage()
{
   [ -n "$1" ] && ech "$name: $1" >&2
   exit 1
}

getpasswort()
{
   echo -n "Password: " >&2
   stty -echo > $DEVNULL 2>&1
   read passwort
   stty echo > $DEVNULL 2>&1
   echo "" >&2
}
   
   
# Parameter auswerten
OPTSTR="p:l:"
non_opt_args=""
non_opt_index=0
LANG=""

while [ $OPTIND -le $# ]
do
    while getopts "$OPTSTR" arg
    do
       case $arg in
        p) passwort="$OPTARG"  ;;
        l) LANG="$OPTARG"  ;;
        *) echo "fehlerhafte Option / incorrect option"
           usage ;;      # fehlerhafte Option
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

   
# Evtl. Passwort erfragen
   [ -z "$passwort" ] && getpasswort
   [ -z "$passwort" ] && usage "Passwort fehlt! / Password missing!"
   
#   [ -z "$LANG" ] && usage "Angabe der Sprache fehlt! -l D/A"
   
#if [ ! $LANG = "D" -a ! $LANG = "A" ] ; then
#  usage "Es sind nur D oder A für die Sprache erlaubt"
#fi

###################################################################################################
# Import Stammdaten                                                                               #
###################################################################################################

MSGFILE="owinstall/abas-pm/PM.IMP.IMPORT"
IMPORTDIR="owinstall/abas-pm"

cd $MANDANTDIR

#Da Nummer 8 im Personal schon existiert in 27 ändern
#echo '8;27' | edpimport.sh -p $passwort -H $MSGFILE -a UPDATE -b 150:1 -f 'nummer;nummer'

#ini Dateien erzeugen
IMPORT="$IMPORTDIR/00.ps.konfig.init.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/01.standardkontierung.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/03.kostenarten.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/04.konten.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/04.2.kontenbereich.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/05.zusatzpositionen.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/06.dienstleistungen.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#existieren bereits
#IMPORT="$IMPORTDIR/07.kostenrechnungseinheit.edp"
#edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/08.leistungsarten.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/09.gewerk.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/46.rechenregel.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/11.zuschlagsatz.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/12.kostenkomponente.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/13.kalkulationsschema.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/14.projekttyp.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/15.kostentraeger.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/16.kostenstelle.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#IMPORT="$IMPORTDIR/47.bezugsgroessel.edp"
#edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/48.bab-formular.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/00.ps.konfiguration.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/10.verteilerschluessel.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/17.personal.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#Pasworte bereits drin - Personal nachtragen
IMPORT="$IMPORTDIR/17.1.passwort.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/18.projektteam.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/19.verrechnungssatz.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/19.1.zuschlagssatzwert.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/20.arbeitspaketvorlage.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/21.checklistenvorlagen.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/22.nummernkreis.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT


exit 0