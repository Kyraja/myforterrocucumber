<#--
 *****************************************************************************
  Name           : EV_AUSS.ftl
  Autor          : mibr
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von Ausschreibungsvorgaengen

 *****************************************************************************
-->
--------------------------------------------------------------------------------------------
${scenario!"-leer-"}
--------------------------------------------------------------------------------------------

Suchwort......................: <#if ablagef == "ja">+</#if>${such}
Bezeichnung...................: ${name}
Beschaffungsart...............: ${bsart}

 <#if rows?size != 0>
<#assign kopf>
${"sel"?trim?       right_pad(12)}
${"tlief"?trim?     right_pad (14)}
${"preisok"?        right_pad (13)}
${"mgediff"?        right_pad (12)}
${"artikel"?        right_pad (16)}
${"posstatus"?      right_pad (14)}
${"preis"?          right_pad (22)}
${"zwaehr"?         right_pad (17)}
${"proz"?           right_pad (17)}
${"ttterm"?         right_pad (14)}
${"tevkopf"?        right_pad (14)}
${"anfrposgrp"?     right_pad (16)}
${"verw"?trim?      right_pad (14)}
<#-- ${"anfr-bsart"?right_pad (12)} -->
<#-- ${"rechnung"?  right_pad (12)} -->
${"lbed"?           right_pad (16)}
${"lgruppe"?        right_pad (16)}
<#-- ${"projekt"?   right_pad (12)} -->
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.sel?trim?     right_pad (12)}
${row.tlief?trim?   right_pad (14)}
${row.preisok?trim? right_pad (13)}
${row.mgediff?trim? right_pad (12)}
${row.artikel?      right_pad (16)}
${row.tevposstatus? right_pad (14)}
${row.preis?        right_pad (22)}
${row.zwaehr?       right_pad (17)}
${row.proz?         right_pad (17)}
${row.ttterm?       right_pad (14)}
${row.tevkopf?      right_pad (14)}
${row.anfrposgrp?   right_pad (16)}
${row.verw?trim?    right_pad (14)}
<#-- ${row.tevkopf^bsart?    right_pad (12)} -->
<#-- ${row.tevkopf^rechnung? right_pad (12)} -->
${row.lbedname?right_pad(15)?substring(0, 15)}
${row.lgruppe?      right_pad (16)}
<#-- ${row.projekt^such?     right_pad (12)} -->
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>

