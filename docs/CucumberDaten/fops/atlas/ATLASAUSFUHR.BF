..!interpreter english translate noabbrev
..*****************************************************************************
.. FOP-Name       : ATLASAUSFUHR.BF
.. Autor          : mh
.. Verantwortlich : mh
.. Kontrolle      : cl
.. Funktion       : Nach FÅllen der Infosystemfelder Kopf+Tabelle wird
..                  sofort die FeldprÅfung gestartet.
.. Functionality  : After filling all infosystem fields in header and table
..                  field validation is started at once.
..*****************************************************************************
.set trans -
..
..
.. Gewichte summieren, falls nicht aus Vorgang Åbernommen
..
.continue ESUM    ? _F|empty(M|kbruttogew)
.select screen header
!NSUM
.select screen line
.continue ESUM    ? _T|mehr
.formula M|kbruttogew = M|kbruttogew + M|trohmasse
.continue NSUM
!ESUM
..
..
.. Nach dem FÅllen der Felder sofort einmal die PrÅfung starten, um
.. leere Felder farblich hervorzuheben.
..
.input "atlas/ATLASAUSFUHR.KBUPRUEFEN.BN"
..
..*****************************************************************************
!END
.continue
