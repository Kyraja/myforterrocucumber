..!interpreter english declaration
..
.set TRANS -
..
.. FOP.6.ZBEDTERM.MP
.. alltrotec/CP         25.06.08
..
.. Hilfs-FOP fÅr Erzeugung von Buchungen aus Transaktion
.. abas ersetzt nach Eintragen eines Personenkontos die Zahlungsbedingung,
.. FÑlligkeit und Steuer - mit diesem FOP wird der Wert aus der Schnittstelle
.. wieder eingetragen bzw. die FÑlligkeit fixiert
..
.. FOP an MaskenprÅfung anschalten
.........................................................................
..
.continue                               ? _G|edp
..
.continue                               ?  m|yprjmszbed = "" & F|empty(m|yprjmsterm)
..
.select screen header
.. Zahlungsbedingung ersetzen
.formula m|zbed   = m|yprjmszbed^id     ? _m|yprjmszbed = ""
.. FÑlligkeit ersetzen
.formula m|zbed   = ""                  ? _F|empty(m|yprjmsterm)
.formula m|term   = m|yprjmsterm        ? _F|empty(m|yprjmsterm)
.formula m|mterm  = G|true              ? _F|empty(m|yprjmsterm)
!LINE: Steuer ersetzen
.select screen line
.continue END                           ? _mehr
.formula m|steuer = m|yprjmssteuer      ? _F|empty(m|yprjmssteuer)
.continue LINE
!END:
.continue
