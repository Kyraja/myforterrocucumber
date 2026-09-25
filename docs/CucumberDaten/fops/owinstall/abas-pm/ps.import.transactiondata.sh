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
# Import Bewegungsdaten                                                                                          #
###################################################################################################

MSGFILE="owinstall/abas-pm/PM.IMP.IMPORT"
IMPORTDIR="owinstall/abas-pm"

cd $MANDANTDIR
cp ${IMPORTDIR}/UPDATE.ID.KALKPOS ./rmtmp/
cp ${IMPORTDIR}/UPDATE.REFERENZ.PV ./rmtmp/

IMPORT="$IMPORTDIR/23.projekt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/24.teilprojekt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/25.auftrag.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/26.projekt.vorgang.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/27.projektvorgang.stufe0.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/28.projektvorgang.stufe1.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/29.projektvorgang.zeilen.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/29.1.projektvorgang.referenz.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/29.2.projektvorgang.checklistenvorlage.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/30.arbeitsaufgabe.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/31.arbeitsaufgabe.pvakt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/32.leistungsmeldung.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/33.leistungsmeldung.pvakt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/34.leistungsmeldung.buch.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#Checklisten
IMPORT="$IMPORTDIR/54.checkliste.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/35.bestellvorschlag.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/36.fertigungsvorschlag.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#IMPORT="$IMPORTDIR/37.leistungsverzeichnis.edp"
#edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#IMPORT="$IMPORTDIR/38.leistungsverzeichnis.position.edp"
#edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#IMPORT="$IMPORTDIR/39.leistungsverzeichnis.position.upos.edp"
#edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/40.kalkulationsblatt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/41.kalkulationsblatt.position.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/42.leistungsliste.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/43.kalkulationsblatt.position.update.verweis.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/44.leistungsliste.update.kalkpos.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/45.deckblatt.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT

#Statistiken laufen lassen
IMPORT="$IMPORTDIR/49.statistiken.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#Lieferschein anlegen
IMPORT="$IMPORTDIR/50.lieferschein.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
#Rechnung buchen
IMPORT="$IMPORTDIR/51.rechnung.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/52.rueckmeldung.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT
IMPORT="$IMPORTDIR/53.kostenbuchungsvorschlag.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT

#Referenzdatum PV seten
IMPORT="$IMPORTDIR/55.pvrefdat.edp"
edpimport.sh -p $passwort -H $MSGFILE -I $IMPORT

#Transaktionen buchen
EKSPASSWORT=$passwort export EKSPASSWORT ; batchlg.sh "allpstart/FOP.MASK.TRANSACTION" >>$MSGFILE

exit 0