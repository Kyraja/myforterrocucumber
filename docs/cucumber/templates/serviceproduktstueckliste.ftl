<#--
 *****************************************************************************
  Name           : serviceproduktstueckliste.ftl
  Autor          : as
  Verantwortlich : teampss
  Funktion       : Freemarker-Template zur Ausgabe von
                   Serviceproduktstuecklisten.

 *****************************************************************************
-->

-- Serviceproduktstueckliste -----------------------------------------------------------------------------------

Nummer..........: ${nummer?  right_pad(12)}
Serviceprodukt..: ${serprod? right_pad(12)}
Artikel.........: ${artikel? right_pad(12)}
Charge..........: ${charge?  right_pad(12)}

<#if rows?size != 0>
<#assign kopf>
${"znum"?      right_pad  (4)} | 
${"elex"?      right_pad (12)} | 
${"elanzahl"?  right_pad  (8)} | 
${"elle"?      right_pad  (8)} | 
${"einsatzv"?  right_pad  (8)} | 
${"einsatzb"?  right_pad  (8)} | 
${"res"?       right_pad  (4)} | 
${"ljzu"?      right_pad (14)} | 
${"ljab"?      right_pad (14)} | 
${"zcharge"?   right_pad (12)} | 
${"serstl"?    right_pad (12)} 
</#assign>
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.znum?      right_pad  (4)} | 
${row.elex?      right_pad (12)} | 
${row.elanzahl?  right_pad  (8)} | 
${row.elle?      right_pad  (8)} | 
${row.einsatzv?  right_pad  (8)} | 
${row.einsatzb?  right_pad  (8)} | 
${row.res?       right_pad  (4)} | 
${row.ljzu?      right_pad (14)} | 
${row.ljab?      right_pad (14)} | 
${row.zcharge?   right_pad (12)} | 
${row.serstl?    right_pad (12)} 
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Stuecklistenzeilen!
</#if>
