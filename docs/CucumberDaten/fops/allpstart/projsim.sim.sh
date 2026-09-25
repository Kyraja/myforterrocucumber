#!/bin/sh
#
# Name             : projsim.sim.sh
# Funktion         : Start der Simulation
# Autor            : Thomas Saalborn
# Copyright        : (c)1990-2013 alltrotec GmbH
#

myexit() {
    exit $1
}

usage()
{ echo "" >&2
  echo "usage: $name [ -p ][ -s]" >&2
  echo "       -x : Projekt"
  echo "       -s : Suffix"
  echo "       -f : Datei"
   [ -n "$1" ] && echo "$name: $1" >&2
   myexit 1
}

# start Hauptprogramm

# Parameter auswerten
OPTSTR="f:s:x:"
non_opt_args=""
non_opt_index=0

while [ $OPTIND -le $# ]
do
    while getopts "$OPTSTR" arg
    do
       case $arg in
        x) project="$OPTARG"  ;;
		s) suffix="$OPTARG"  ;;
        f) file="$OPTARG"  ;;
		*) echo "fehlerhafte Option"
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

# Suffix wenn leer
[ -z "$suffix" ] && usage

PRSIMPATH=win/projectsuite/projsim/Modeller/bin_linux/

cd $MANDANTDIR/$PRSIMPATH
# wenn Datei übergeben wird - nix übergeben - Simulation findet Datei im Datenverzeichnis
./simsh ../prjmskript/init.tcl $suffix $project

exit $?