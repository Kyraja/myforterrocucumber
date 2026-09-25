<#--
 *****************************************************************************
  Name           : objlocks_actionmenu.ftl
  Autor          : fwester
  Verantwortlich : @forterro-prd/t024-abas-core
  Kontrolle      :
  Funktion       : Freemarker-Template, dass man braucht, um die Ausgabe von
                   IDs korrekt zu normalisieren.
                   Es gibt Eigenschaften aus der Zeile NNNNN des Aktionsmenues
                   aus.
                   Siehe ref_objlocks_actionmenu
 *****************************************************************************
-->
[Szenario: ${scenario!"-leer-"}]

Aktionsmenue "${menuetitel}":

<#if rows?size != 0>
 <#list rows as row>
  <#assign callparam = row.taufrufparameter>
  <#if callparam == "53226">
Aktiv          : [${row.taktiv}]
Ausfuehrbar    : [${row.tmenuemoeglich}]
Aufrufparameter: [${row.taufrufparameter}]
Dialogart      : [${row.tdialogart}]
Sichtbar       : [${row.tsichtbar}]
GUI-Kommando   : [${row.tkommando}]
   -Parameter  : [${row.tparams}]
  </#if>
 </#list>
<#else>
FEHLER: Es wurden keine Eintraege gefunden!
Das Menue "${menuetitel}" muss aber Eintraege haben!
</#if>
