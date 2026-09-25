<#--
 *****************************************************************************
  Name           : EV_VORG_BEI_AUSS.ftl
  Autor          : mibr
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Einkaufs- und
                   Verkaufsvorgaengen speziell fuer Test Ausschreibungen.
                   Es werden Felder ausgegeben, die
                   mit der Mengenverrechnung in Verbindung stehen.

 *****************************************************************************
-->
--------------------------------------------------------------------------------------------
${scenario!"-leer-"}
--------------------------------------------------------------------------------------------

<#if dnr == "3">
-- Vorgang Verkauf ---------------------------------------------------------------------------------------------
</#if>
<#if dnr == "4">
-- Vorgang Einkauf ---------------------------------------------------------------------------------------------
</#if>

Typ..........................: ${typa}
Nummer.......................: ${nummer}
Suchwort.....................: ${such}
Ablage.......................: ${ablagef}
<#if typa == "Lieferschein">
Lieferscheinart..............: ${lsart}
</#if>
<#if typa == "Rechnung">
Rechnungsart.................: ${vorganga}
Rechnung mit Lagerbewegung...: ${fakt}
</#if>
<#if (typa == "Lieferschein" || typa == "Rechnung") && (uebertr == "nein")>
Gebucht......................: ja
</#if>
<#if (typa == "Lieferschein" || typa == "Rechnung")  && (uebertr == "ja")>
Gebucht......................: nein
</#if>
Erfassungsdatum..............: ${erfass?substring(0, 10)}
Aenderungsdatum..............: ${stand?substring(0, 10)}
Letzter Bearbeiter...........: ${zeichen}
Beschaffungsart..............: ${bsart}
Kund/Lieferant...............: ${kl}
Betreff......................: ${betreff}
Rechnungsstellung............: ${rechnung}

<#if rows?size != 0>
<#assign kopf>
${"artikel"?    right_pad (10)} |
${"tename"?     right_pad (30)} |
${"ofmge"?      right_pad (10)} |
${"mge"?        right_pad (10)} |
${"limge"?      right_pad (10)} |
${"remge"?      right_pad (10)} |
${"lifrg"?      right_pad (10)} |
${"refrg"?      right_pad (10)} |
${"term"?       right_pad (10)} |
${"oterm"?      right_pad (10)} |
${"preis"?      right_pad (10)} |
${" "?          right_pad (4)}  |
${"pwert"?      right_pad (10)} |
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.artikel?  right_pad (10)} |
${row.tename?   right_pad (30)} |
${row.ofmge?    right_pad (10)} |
${row.mge?      right_pad (10)} |
${row.limge?    right_pad (10)} |
${row.remge?    right_pad (10)} |
${row.lifrg?    right_pad (10)} |
${row.refrg?    right_pad (10)} |
${row.term?     right_pad (10)} |
${row.oterm?    right_pad (10)} |
${row.preis?    right_pad (10)} |
${row.zwaehr?   right_pad (10)} |
${row.pwert?    right_pad (10)} |
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>

