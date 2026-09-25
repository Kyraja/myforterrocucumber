<#--
 *****************************************************************************
  Name           : EV_RUECK_MZ.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Materialzuordnungen.
                   Es werden Felder ausgegeben, die bei Storno und
                   Ruecklieferungen bezueglich der der  MZ-Generierung und
                   -Zuordnung wichtig sind.

 *****************************************************************************
-->

[Szenario: ${scenario!"-leer-"}]

-- Materialzuordnungen -----------------------------------------------------------------------------------------

Artikel......................: ${artikel}
Vorgangsart..................: ${mzart}
Vorgangsmenge=Tabellensumme..: ${mzueb}

Gesamtmenge..................: ${loffen?    right_pad(8)} ${levorg}
Verteilt.....................: ${lverteilt? right_pad(8)} ${levorg}
Restmenge....................: ${lresmge?   right_pad(8)} ${levorg}

<#if rows?size != 0>
<#assign kopf>
${"pos"?            right_pad  (4)} | 
${"aktiv"?          right_pad  (5)} | 
${"lpsuch"?         right_pad  (8)} | 
${"zuomge"?         right_pad  (8)} | 
${"restmgeplatz"?   right_pad (12)} | 
${"restmgeplatzle"? right_pad (14)} | 
${"restmge"?        right_pad  (8)} | 
${"restmgele"?      right_pad (12)} | 
${"ljorig"?         right_pad  (8)} | 
${"einh"?           right_pad  (8)} | 
${"faktor"?         right_pad  (8)} | 
${"verw"?           right_pad (12)} | 
${"projekt"?        right_pad (12)} | 
${"charge"?         right_pad (12)} | 
${"kzbew"?          right_pad (12)} | 
${"kabew"?          right_pad (12)} | 
${"kbs"?            right_pad (12)} | 
${"kres"?           right_pad (12)}
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#if row.ljorig != "(0,0,0)">
<#assign ljorig>OK</#assign>
<#else>
<#assign ljorig>-leer-</#assign>
</#if>
<#assign zeile>
${row.pos?            right_pad  (4)} | 
${row.aktiv?          right_pad  (5)} | 
${row.lpsuch?         right_pad  (8)} | 
${row.zuomge?         right_pad  (8)} | 
${row.restmgeplatz?   right_pad (12)} | 
${row.restmgeplatzle? right_pad (14)} | 
${row.restmge?        right_pad  (8)} | 
${row.restmgele?      right_pad (12)} | 
${ljorig?             right_pad  (8)} | 
${row.einh?           right_pad  (8)} | 
${row.faktor?         right_pad  (8)} | 
${row.verw?           right_pad (12)} | 
${row.projekt?        right_pad (12)} | 
${row.charge?         right_pad (12)} | 
${row.kzbew?          right_pad (12)} | 
${row.kabew?          right_pad (12)} | 
${row.kbs?            right_pad (12)} | 
${row.kres?           right_pad (12)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
<#if row.verw2?length gt 0 || row.projekt2?length gt 0 || row.umcharge?length gt 0>
<#assign zeile>
${""?             right_pad  (4)} | 
${""?             right_pad  (5)} | 
${""?             right_pad  (8)} | 
${""?             right_pad  (8)} | 
${""?             right_pad (12)} | 
${""?             right_pad (14)} | 
${""?             right_pad  (8)} | 
${""?             right_pad (12)} | 
${""?             right_pad  (8)} | 
${""?             right_pad  (8)} | 
${""?             right_pad  (8)} | 
/ ${row.verw2?    right_pad (10)} | 
/ ${row.projekt2? right_pad (10)} | 
/ ${row.umcharge? right_pad (10)} | 
${""?             right_pad (12)} | 
${""?             right_pad (12)} | 
${""?             right_pad (12)} | 
${""?             right_pad (12)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#if>
</#list>
<#else>
Keine Materialzuordnungen!
</#if>
