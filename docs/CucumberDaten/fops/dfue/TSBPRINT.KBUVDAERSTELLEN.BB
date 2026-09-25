..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : TSBPRINT.KBUVDAERSTELLEN.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Convert edi shipping from inhouse format to vda format.
...Includes       : 
..  include dfue/TSBPRINT.IHSS2VDA
..*****************************************************************************
..!meta M|=dfue/TSBPRINT
.set trans -
.. 
.continue NOFILES ? _M|kbihssvorhanden
.. 
.. Shipping order in inhouse format 
.type text xtinhousefile
.formula U|xtinhousefile = M|kihssdatei
.. 
.. Shipping order in vda format 
.type text xtvda4tsb
.formula U|xtvda4tsb = M|kimportdatei
..
.. Create import file in vda format from file with inhouse format 
.input "TSBPRINT.IHSS2VDA"
.. 
.. Check which import file was created successfully
.formula M|kbimportvorhanden = F|fileexists(M|kimportdatei) & _F|isdir(M|kimportdatei) & F|filesize(M|kimportdatei)>0
.. 
..*****************************************************************************
!END
.continue
.. 
.. 
!NOFILES
.error Zur Erstellung der VDA-Datei muss der Speditionsauftrag als Inhousedatei vorhanden sein.
.end 1
