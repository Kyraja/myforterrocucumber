<#--
 *****************************************************************************
  Name           : EV_VORG_RUECK_MZ.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Einkaufs- und
                   Verkaufsvorgaengen. Es werden Felder ausgegeben, die bei
                   Storno und Ruecklieferungen bezueglich der der
                   MZ-Generierung und -Zuordnung wichtig sind.

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
<#if (typa == "Lieferschein")>
Lieferscheinart..............: ${lsart}
</#if>
Nummer.......................: ${nummer}
Ablage.......................: ${ablagef}
<#if (typa == "Lieferschein") && (uebertr == "nein")>
Gebucht......................: ja
</#if>
<#if (typa == "Lieferschein")  && (uebertr == "ja")>
Gebucht......................: nein
</#if>

<#if rows?size != 0>
<#assign kopf>
${"pos"?     right_pad  (9)} | 
${"artikel"? right_pad (20)} | 
${"ofmge"?   right_pad (11)} | 
${"mge"?     right_pad  (9)} | 
${"he"?      right_pad  (8)} | 
${"lehe"?    right_pad (12)} | 
${"platz"?   right_pad (10)} | 
${"verw"?    right_pad (20)} | 
${"projekt"? right_pad (15)} | 
${"charge"?  right_pad (10)}
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${(row_index+1)? right_pad  (9)} | 
${row.artikel?   right_pad (20)} | 
${row.ofmge?     right_pad (11)} | 
${row.mge?       right_pad  (9)} | 
${row.he?        right_pad  (8)} | 
${row.lehe?      right_pad (12)} | 
${row.platz?     right_pad (10)} | 
${row.verw?      right_pad (20)} | 
${row.projekt?   right_pad (15)} | 
${row.charge?    right_pad (10)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>
