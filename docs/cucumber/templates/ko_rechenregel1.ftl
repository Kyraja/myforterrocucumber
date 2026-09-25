<#-- verantwortlich: uo -->
<#-- joins mit ^ sind in templates NICHT möglich! -->

Daten zu ${objgrbez}: Suchwort ${such}, Nummer ${nummer}, Berechnungsart ${optyp}   
<#if rows??>
   zn     stufe       koart       ikum    
---------------------------------------
<#list rows as row>
${row.zn?right_pad(9)} ${row.tbaumstufe?right_pad(10)} ${row.koart?right_pad(10)} ${row.ikum?right_pad(6)}
</#list>
</#if>
---------------------------------------
Ist-kosten Kopf kikum: ${kikum?left_pad(14)}
