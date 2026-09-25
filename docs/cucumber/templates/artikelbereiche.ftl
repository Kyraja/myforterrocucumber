<#--
 *****************************************************************************
  Name           : artikelbereiche.ftl
  Autor          : foe
  Verantwortlich : foe
  Kontrolle      : as
  Funktion       : Freemarker-Template zur Ausgabe von Artikelbereichen.
                   Verwendet im Referenztest ref_artikelbereiche. Gibt
                   Artikelbereiche aus, die das Cucumber-Script artberdiv.feature
                   anlegt oder veraendert.

 *****************************************************************************
-->

<#if dnr == "84">
-- A r t i k e l b e r e i c h --------------------------------------------------

Suchwort                  : ${such}
Name                      : ${namebspr}

<#if rows?size != 0>
<#assign kopf>
${"Artikelbereich"?     right_pad (14)} |
${"Artikel"?            right_pad (10)} |
${"Selektionsleiste"?   right_pad (16)} |
${"Name"?               right_pad (44)} |
${"Katalog"?            right_pad  (8)} |
${"Planung"?            right_pad  (8)} |
${"Kategorie"?          right_pad (20)}
</#assign>
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<#assign kopf>${kopf?replace("\\n|\\r", "", "rm")}</#assign>
${kopf}
<#list 1..kopf?length as i>-</#list>
<#list rows as row>
<#assign zeile>
${row.abereich?    right_pad (14)} |
${row.artikel?     right_pad (10)} |
${row.selekt?      right_pad (16)} |
${row.zname?       right_pad (44)} |
${row.catactiv?    right_pad  (8)} |
${row.plaktiv?     right_pad  (8)} |
${row.kategorie?   right_pad (20)}
</#assign>
${zeile?replace("\\n|\\r", "", "rm")}
</#list>
<#else>
Keine Positionen!
</#if>
------------------------------------------------------------------------------------------------------------------------------------------------
<#else>

</#if>
