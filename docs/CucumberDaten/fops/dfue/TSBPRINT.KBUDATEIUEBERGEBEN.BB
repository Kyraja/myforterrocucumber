..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : TSBPRINT.KBUDATEIUEBERGEBEN.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Copies import file (vda format) into the import directory 
..                  of the TSB utility.
..*****************************************************************************
..!meta M|=dfue/TSBPRINT
.set trans -
..
.continue NOFILE ? _M|kbimportvorhanden
.. 
.system 'F|formatstr("cp -f {1} {2}", M|kimportdatei, M|kvdadatei)' background
.. 
.formula M|kbvdavorhanden = F|fileexists(M|kvdadatei) & _F|isdir(M|kvdadatei) & F|filesize(M|kvdadatei)>0
.. 
..*****************************************************************************
!END
.continue
.. 
..
!NOFILE
.error Es ist keine Importdatei vorhanden!
.end 1
