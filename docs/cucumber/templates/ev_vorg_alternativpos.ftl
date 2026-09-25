<#--
 *****************************************************************************
  Name           : ev_vorg_alternativpos.ftl
  Autor          : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Einkaufs- und
                   Verkaufsvorgaengen. Es werden Felder ausgegeben, die
                   mit Alternativpositionen in Verbindung stehen.

 *****************************************************************************
-->

[Szenario: ${scenario!"-leer-"}]

<#if dnr == "3">
-- Vorgang Verkauf ---------------------------------------------------------------------------------------------
</#if>
<#if dnr == "4">
-- Vorgang Einkauf ---------------------------------------------------------------------------------------------
</#if>

Typ..........................: ${typa?      trim}
Ablage.......................: ${ablagef?   trim}
Nummer.......................: ${nummer?    trim}
Suchwort.....................: ${such?      trim}
Bruttopreise.................: ${brutto?    trim}
Bruttosumme..................: ${sumbrutto? trim}
Nettosumme...................: ${sumnetto?  trim}
Steuerbuchungsart............: ${ustart?    trim}
Liefergewicht brutto.........: ${bruttogew? trim}
Liefergewicht netto..........: ${nettogew?  trim}

<#if rows?size != 0>
<#assign kopf>
${"pnum"?        right_pad  (4)} | 
${"altpos"?      right_pad  (7)} | 
${"altgrp"?      right_pad  (7)} | 
${"art"?         right_pad (12)} | 
${"mge"?         right_pad  (6)} | 
${"einplan"?     right_pad  (7)} | 
${"status"?      right_pad  (6)} | 
${"lirelev"?     right_pad  (7)} | 
${"rerelev"?     right_pad  (7)} | 
${"limge"?       right_pad  (6)} | 
${"remge"?       right_pad  (6)} | 
${"ls"?          right_pad  (4)} | 
${"re"?          right_pad  (4)} | 
${"preis"?       right_pad  (9)} | 
${"proz"?        right_pad  (5)} | 
${"pwert"?       right_pad  (9)} | 
${"nwert"?       right_pad  (9)} | 
${"stwert"?      right_pad  (9)} | 
${"rabmge"?      right_pad  (6)} | 
${"prgmge"?      right_pad  (6)} | 
${"posgewicht"?  right_pad  (9)}
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.pnum?          right_pad  (4)} | 
${row.alternativpos? right_pad  (7)} | 
${row.alternativgrp? right_pad  (7)} | 
${row.artikel?       right_pad (12)} | 
${row.mge?           right_pad  (6)} | 
${row.einplan?       right_pad  (7)} | 
${row.status?        right_pad  (6)} | 
${row.lirelev?       right_pad  (7)} | 
${row.rerelev?       right_pad  (7)} | 
${row.limge?         right_pad  (6)} | 
${row.remge?         right_pad  (6)} | 
${row.ls?            right_pad  (4)} | 
${row.re?            right_pad  (4)} | 
${row.preis?         right_pad  (9)} | 
${row.proz?          right_pad  (5)} | 
${row.pwert?         right_pad  (9)} | 
${row.nwert?         right_pad  (9)} | 
${row.stwert?        right_pad  (9)} | 
${row.rabmge?        right_pad  (6)} | 
${row.prgmge?        right_pad  (6)} | 
${row.posgewicht?    right_pad  (9)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>
