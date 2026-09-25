..!interpreter german translate noabbrev
..*****************************************************************************
.. Name           : owfo/TEMPLATEAUSWAHL.AUSGEWAEHLT.FX
.. Date           : 20.11.15
.. Version        : 2016r2n01
.. Author         : andre
.. Copyright      : (c) 2015 SABA International
.. Functionality  :  wenn ein Datensatz mit Verweisen auf Templates in der Tabelle ausgewÑhlt wurde,
..                   mÅssen auch diese DatensÑtz merkiert werden.
..
.. Interface (arguments and their meaning)
..    uses array argument (arg.i)           : no
..    uses name argument  (xpname=value)    : no
..
..    Argument     meaning
..    -------------------------------------------------------------------------
..
.. Program flow   :
...Includes       :
..*****************************************************************************
..
..*****************************************************************************
..
.. 
..
.hol dazu m|tempsuch
.art bool xausgewaehlt
.fo xausgewaehlt = m|ausgewaehlt
..
!TEMPZEILE:
.hol zeile
.weiter ETEMPZEILE ? _ mehr
.weiter TEMPZEILE  ? h|y40tytemp = ""
.art text xy40tytemp
.formel xy40tytemp = 'h|y40tytemp^id'
.weiter PRöFUNG


!PRöFUNG:
.hol maske kopf
!MZEILE:
.hol maske zeile
.weiter EMZEILE ? _ mehr
.formel m|ausgewaehlt = xausgewaehlt  ? 'm|tempsuch^id' = xy40tytemp
.weiter MZEILE

!EMZEILE:
.weiter TEMPZEILE

!ETEMPZEILE:
.ende
