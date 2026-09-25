<#--
 *****************************************************************************
  Name           : EV_BV.flt
  Autor          : mibr
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von BVs.

 *****************************************************************************
-->
--------------------------------------------------------------------------------------------
${scenario!"-leer-"}
--------------------------------------------------------------------------------------------

-- Bestellvorschlaege ------------------------------------------------------------------------------------------

<#if rows?size != 0>
<#assign kopf>
${"artex"?      right_pad (10)} |
${"tename"?     right_pad (20)} |
${"lief"?       right_pad (10)} |
${"mge"?        right_pad (10)} |
${"term"?       right_pad (10)} |
${"preis"?      right_pad (10)} |
${"pwert"?      right_pad (10)} |
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.artex?  right_pad (10)} |
${row.tename?   right_pad (20)} |
${row.lief?    right_pad (10)} |
${row.mge?      right_pad (10)} |
${row.term?    right_pad (10)} |
${row.preis?    right_pad (10)} |
${row.pwert?    right_pad (10)} |
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Zeilen!
</#if>

