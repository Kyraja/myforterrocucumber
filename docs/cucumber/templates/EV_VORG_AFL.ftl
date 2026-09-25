<#--
 *****************************************************************************
  Name           : EV_VORG_AFL.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Fertigungslisten
                   zu Einkaufs- und Verkaufsvorgaengen.

 *****************************************************************************
-->

[Szenario: ${scenario!"-leer-"}]

-- Fertigungsliste ---------------------------------------------------------------------------------------------

<#if rows?size != 0>
<#assign kopf>
${"elex"?    right_pad (15)} | 
${"tr"?      right_pad  (8)} | 
${"te"?      right_pad  (8)} | 
${"anzahl"?  right_pad  (8)} | 
${"mge"?     right_pad  (8)} | 
${"limge"?   right_pad  (8)} | 
${"einplan"? right_pad  (8)} | 
${"status"?  right_pad  (8)}
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.elex?    right_pad (15)} | 
${row.tr?      right_pad  (8)} | 
${row.te?      right_pad  (8)} | 
${row.anzahl?  right_pad  (8)} | 
${row.mge?     right_pad  (8)} | 
${row.limge?   right_pad  (8)} | 
${row.einplan? right_pad  (8)} | 
${row.status?  right_pad  (8)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>
