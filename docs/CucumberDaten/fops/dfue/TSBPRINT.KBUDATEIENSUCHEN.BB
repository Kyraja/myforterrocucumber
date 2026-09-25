..!interpreter english translate noabbrev
..*****************************************************************************
.. Name           : TSBPRINT.KBUDATEIENSUCHEN.BB
.. Author         : mh
.. Verantwortlich : mh
.. Kontrolle      :
.. Functionality  : Searches if the TSB utility did consume the VDA file and 
..                  create a TSB file or a GTL file.
..                    
..                  In the screen the check boxes M|kbtsb and M|kbgtl can be 
..                  marked to wait and check several times.
..                  
..                  If the check boxes are not marked, files are only seached 
..                  one time!
..                    
..                  Sleep duration and the number of intevalls are defined 
..                  in the FO program dfue/TSB.INIT.
..                  On mask entry the efop dfue/TSBPRINT.ME reads the settings
..                  into the fields M|ksleep and M|kmaxwait.
..              
..                  Default setting (assuming kbtsb or kbgtl are marked) is to 
..                  search for files 5 times with a 1 second sleep.
..*****************************************************************************
..!meta M|=dfue/TSBPRINT
.set trans -
..
.type integer searchCounter 
.formula U|searchCounter = 0
.. 
!SEARCH : search for tsb / gtl files
.formula U|searchCounter = U|searchCounter +1
.formula M|kbvdavorhanden = F|fileexists(M|kvdadatei) & _F|isdir(M|kvdadatei) & F|filesize(M|kvdadatei)>0
.formula M|kbtsbvorhanden = F|fileexists(M|ktsbdatei) & _F|isdir(M|ktsbdatei) & F|filesize(M|ktsbdatei)>0
.formula M|kbgtlvorhanden = F|fileexists(M|kgtldatei) & _F|isdir(M|kgtldatei) & F|filesize(M|kgtldatei)>0
.continue WAIT  ? _M|kbtsbvorhanden & M|kbtsb 
.continue WAIT  ? _M|kbgtlvorhanden & M|kbgtl
.continue END
.. 
!WAIT : wait a few seconds and try searching again
.continue END ? U|searchCounter > M|kmaxwait
.system 'F|formatstr("sleep {1}s", M|ksleep)' background
.continue SEARCH
.. 
..*****************************************************************************
!END
.continue
