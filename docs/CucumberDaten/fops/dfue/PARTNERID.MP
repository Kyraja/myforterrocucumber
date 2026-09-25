..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : PARTNERID.MP
.. Autor          : mh/ok
.. Verantwortlich : mh
.. Kontrolle      : carue
.. Funktion       : PartnerId-Mapping in Datei schreiben
.. Functionality  : Write PartnerId mapping to file
...Includes       :
..  include  dfue/PARTNERID.NEUEDATEI
..*****************************************************************************
.set trans -
..
.. Nothing to do
.continue END  ?  F|empty(M|kedinachr) ; F|empty(M|kdatei)
.continue END  ?  M|tzeilen = 0  &  _M|kbgeladen
..
.. Initialize file!
.. Content will be re-written from table.
.. Note: no rows but "read" (kbgeladen) will delete the old mapping!
.input "dfue/PARTNERID.NEUEDATEI"
..
.output addedto 'M|kdatei'
.select screen header
.continue ENDROWS  ? _G|mehr
!NEXT
.select screen line
.continue ENDROWS  ? _G|mehr
'M|ersetzt'#'M|kunde'#'M|werk'#'M|ablade'#'M|kommentar'#
.continue NEXT
!ENDROWS
.output
..          
.. After writing reset cancel-question on closing window.
.formula M|abbrfrage = G|false
..*****************************************************************************
!END
.continue
