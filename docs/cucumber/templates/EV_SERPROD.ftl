<#--
 *****************************************************************************
  Name           : EV_SERPROD.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Serviceprodukten.

 *****************************************************************************
-->

[Szenario: ${scenario!"-leer-"}]

-- Serviceprodukt ----------------------------------------------------------------------------------------------

Nummer.......................: ${nummer?trim}
Typ des Serviceprodukts......: ${serprodtyp?trim}
Artikel......................: ${artikel?trim}
Verkaufsvorgang..............: ${auftrag?trim}
Journaleintrag des Abgangs...: ${spljab?trim}
Lieferdatum..................: ${liefdg?trim}
Interne Seriennummer.........: ${charge?trim}
Stueckliste..................: ${serstl?trim}
Standort/Kunde...............: ${kunde?trim}
Standort/Name................: ${ans?trim}

