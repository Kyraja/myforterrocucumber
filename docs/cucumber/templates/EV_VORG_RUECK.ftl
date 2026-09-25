
[Szenario: ${scenario!"-leer-"}]

<#if dnr == "3">
-- Vorgang Verkauf ---------------------------------------------------------------------------------------------
</#if>
<#if dnr == "4">
-- Vorgang Einkauf ---------------------------------------------------------------------------------------------
</#if>

Typ..........................: ${typa}
Nummer.......................: ${nummer}
Ablage.......................: ${ablagef}
<#if typa == "Lieferschein">
Lieferscheinart..............: ${lsart}
</#if>
<#if umplatz != "">
Umlagern von.................: ${umplatz}
</#if>
<#if typa == "Rechnung">
Rechnung mit Lagerbewegung...: ${fakt}
</#if>
<#if dnr == "4">
Beschaffungsart..............: ${bsart}
</#if>
<#if (typa == "Lieferschein" || typa == "Rechnung") && (uebertr == "nein")>
Gebucht......................: ja
</#if>
<#if (typa == "Lieferschein" || typa == "Rechnung")  && (uebertr == "ja")>
Gebucht......................: nein
</#if>

<#if rows??>
 pos      art       tename               ofmge      mge      pwert       status      ls      re      lifrg      refrg      ruecklifrg  limge      remge      ruecklimge  abmge      platz
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
<#list rows as row>
 ${(row_index+1)?right_pad(9)}${row.artikel?right_pad(10)}${row.tename?right_pad(21)}${row.ofmge?right_pad(11)}${row.mge?right_pad(9)}${row.pwert?right_pad(12)}${row.status?right_pad(12)}${row.ls?right_pad(8)}${row.re?right_pad(8)}${row.lifrg?right_pad(11)}${row.refrg?right_pad(11)}${row.ruecklifrg?right_pad(12)}${row.limge?right_pad(11)}${row.remge?right_pad(11)}${row.ruecklimge?right_pad(12)}${row.abmge?right_pad(11)}${row.platz}
<#if row.abplatz != "">
 Abgangsplatz:  ${row.abplatz} 
</#if>
</#list>
<#else>
Keine Positionen!
</#if>
