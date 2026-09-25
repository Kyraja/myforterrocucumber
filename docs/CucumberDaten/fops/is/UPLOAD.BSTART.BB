..!interpreter english translate noabbrev
..*****************************************************************************
.. Author         : male
.. Verantwortlich : tma
.. Kontrolle      : fwester
.. Functionality  : Start FOP of the Infosystem is/UPLOAD
..*****************************************************************************
..!meta M|=is/UPLOAD
.set trans -
..
.input "is/UPLOAD.INIT"
..
.continue ERR01 ? F|empty(M|filename)
.. the destination file has to exist (touched by .pc.copy in the kernel)
.continue ERR03 ? _F|fileexists(M|filename)
.. the destination file has to empty
.continue ERR03 ?  F|filesize(M|filename) <> 0
.. the destination file has to be in the rmtmp directory
.continue ERR03 ? _F|regmatch(M|filename, "^rmtmp/X.*TMP$")
.continue START
..
..*****************************************************************************
!START
..*****************************************************************************
.type text command tmpfile
.input DATEI.F
.continue V2 ? F|defined(G|tmpfilename)
.continue V1
..
!V1: Pre 2019r4
.file -screen -tempname U|tmpfile
.output new 'U|tmpfile'
.input -text 'M|contentbase64'
.output terminal
.continue CONVERT
..
!V2: Post 2019r4
.file -input 'M|contentbase64'
.formula U|tmpfile = G|tmpfilename
.continue CONVERT
..
!CONVERT
.formula U|command = 'F|formatstr(F|expr("base64- < " + G|apostroph + "{1}" + G|apostroph + " > " + G|apostroph + "{2}" + G|apostroph), U|tmpfile, M|filename)'             ? _M|gzip
.formula U|command = 'F|formatstr(F|expr("base64- < " + G|apostroph + "{1}" + G|apostroph + " | gunzip -c > " + G|apostroph + "{2}" + G|apostroph), U|tmpfile, M|filename)' ?  M|gzip
.system 'U|command' background
.continue ERR02 ? _G|mehr
.continue END
..
..*****************************************************************************
!ERR01
..*****************************************************************************
.set trans +
.formula M|exitstatus = 1
.formula M|errormsg = "Keine Datei angegeben."
.continue ERROR
..
..*****************************************************************************
!ERR02
..*****************************************************************************
.set trans +
.formula M|exitstatus = 2
.formula M|errormsg = "Fehler bei der Konvertierung."
.continue ERROR
..
..*****************************************************************************
!ERR03
..*****************************************************************************
.set trans +
.formula M|exitstatus = 3
.formula M|errormsg = "Zugriff verweigert."
.continue ERROR
..
..*****************************************************************************
!ERROR
..*****************************************************************************
.set trans -
.continue END ? M|exitstatus = 0 ; M|normalexit
.error -message 'M|errormsg'
.end 1
..
..*****************************************************************************
!END
..*****************************************************************************
.continue
