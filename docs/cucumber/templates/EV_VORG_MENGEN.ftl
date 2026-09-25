<#--
 *****************************************************************************
  Name           : EV_VORG_MENGEN.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Einkaufs- und
                   Verkaufsvorgaengen. Es werden Felder ausgegeben, die
                   mit der Mengenverrechnung in Verbindung stehen.

 *****************************************************************************
-->

[Szenario: ${scenario!"-leer-"}]

<#if dnr == "3">
-- Vorgang Verkauf ---------------------------------------------------------------------------------------------
</#if>
<#if dnr == "4">
-- Vorgang Einkauf ---------------------------------------------------------------------------------------------
</#if>

Typ..........................: ${typa}
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

<#if rows?size != 0>
<#assign kopf>
${"pos"?        right_pad  (9)} | 
${"artikel"?    right_pad (20)} | 
${"ofmge"?      right_pad (11)} | 
${"mge"?        right_pad  (9)} | 
${"he"?         right_pad  (8)} | 
${"preis"?      right_pad  (9)} | 
${"pwert"?      right_pad  (9)} | 
${"lifrg"?      right_pad  (9)} | 
${"limge"?      right_pad  (9)} | 
${"ruecklimge"? right_pad (10)} | 
${"ruecklifrg"? right_pad (10)} | 
${"refrg"?      right_pad  (9)} | 
${"remge"?      right_pad  (9)}
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${(row_index+1)?  right_pad  (9)} | 
${row.artikel?    right_pad (20)} | 
${row.ofmge?      right_pad (11)} | 
${row.mge?        right_pad  (9)} | 
${row.he?         right_pad  (8)} | 
${row.preis?      right_pad  (9)} | 
${row.pwert?      right_pad  (9)} | 
${row.lifrg?      right_pad  (9)} | 
${row.limge?      right_pad  (9)} | 
${row.ruecklimge? right_pad (10)} | 
${row.ruecklifrg? right_pad (10)} | 
${row.refrg?      right_pad  (9)} | 
${row.remge?      right_pad  (9)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>
