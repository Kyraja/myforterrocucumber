<#ftl encoding="UTF-8">
<#--
 *****************************************************************************
  Name           : buttonmenu.ftl
  Verantwortlich : @forterro-prd/t024-abas-core
  Funktion       : Freemarker-Template, dass man braucht, um die Ausgabe von
                   IDs korrekt zu normalisieren.
                   Es gibt Eigenschaften aus der Zeile NNNNN des Aktionsmenues
                   aus.
 *****************************************************************************
-->
[Szenario: ${scenario!"-leer-"}]

Menüeinträge aus dem Aktionsmenü "${menuetitel}":

<#if rows?size != 0>
 <#list rows as row>
  <#assign callparam = row.taufrufparameter>
  <#assign rowtype = row.tzeilentyp>
  <#if callparam != "" && rowtype == "Menüeintrag">
Text           : [${row.tbaumtext}]
Aktiv          : [${row.taktiv}]
Ausführbar     : [${row.tmenuemoeglich}]
Aufrufparameter: [${row.taufrufparameter}]
Dialogart      : [${row.tdialogart}]
Sichtbar       : [${row.tsichtbar}]
GUI-Kommando   : [${row.tkommando}]
   -Parameter  : [${row.tparams}]
  </#if>
 </#list>
<#else>
FEHLER: Es wurden keine Einträge gefunden!
Das Menue "${menuetitel}" muss aber Einträge haben!
</#if>
