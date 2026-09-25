@persistent
@FP_TEST
Feature: Testen Konvertierung im Infosystem FTEXTEDITOR

Scenario: Freitext leer beim Öffnen von 
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I press button "baftextbenart" to open a subeditor for "freitexteditor"
Then field "freitextapi" has value "ja"
Then field "ftexteditierbar" has value "ja"
Then field "formathtml" has value "nein"
Then field "freitextinhalt" has value 
"""
"""
And I close the current editor
And I switch the current editor to editor "Auftrag"
Then field "baftextbenart" has value 
"""
"""
And I close the current editor


Scenario: Konvertieren von Freitexte 
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "baftextbenart" to 
"""
<html>
<head>
</head>
<body>
	<pre>Artikel	Anzahl	Preis</pre>
	<pre>Motor	1	1000</pre>
</body>
</html>
"""
And I press button "baftextbenart" to open a subeditor for "freitexteditor"
Then field "freitextapi" has value "ja"
Then field "ftexteditierbar" has value "ja"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""
And I set field "freitextinhalt" to 
"""
<html>
<head>
</head>
<body>
	<pre>Artikel	Anzahl	Preis</pre>
	<pre>Motor	1	1000</pre>
</body>
</html>
"""
And I press button "converttonewhtml"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""

# The old format will no longer be converted into the new one

And I press button "converttonewhtml"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""
And I press button "converttonewhtml"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""

# Convert new editor format to Jasper format

And I set field "freitextinhalt" to 
"""
<table border="0" style="width:30%">
	<tbody>
		<tr>
			<td>Artikel</td>
			<td>Anzahl</td>
			<td>Preis</td>
		</tr>
		<tr>
			<td>Motor</td>
			<td>1</td>
			<td>1000</td>
		</tr>
	</tbody>
</table>
<!-- FTE-Version:1.0.2 -->
"""
And I press button "converttojasper"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""

# The jasper format is no longer converted into jasper again

And I press button "converttojasper"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I save the current editor
And I switch the current editor to editor "Auftrag"
Then field "baftextbenart" has value 
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I set field "kunde" to "1"
And I set field "such" to "FTEXT"
And I create a new row at the end of the table
And I set field "artikel" to "E1" in row 1
And I set field "mge" to "1" in row 1
And I save the current editor


Scenario: Konvertierte Freitext abbrechen
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "NEW" for record ""
And I set field "baftextbenart" to 
"""
<html>
<head>
</head>
<body>
	<pre>Artikel	Anzahl	Preis</pre>
	<pre>Motor	1	1000</pre>
</body>
</html>
"""
And I press button "baftextbenart" to open a subeditor for "freitexteditor"
Then field "freitextapi" has value "ja"
Then field "ftexteditierbar" has value "ja"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">1000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""
And I set field "freitextinhalt" to 
"""
<table border="0" style="width:30%">
	<tbody>
		<tr>
			<td>Artikel</td>
			<td>Anzahl</td>
			<td>Preis</td>
		</tr>
		<tr>
			<td>Motor</td>
			<td>1</td>
			<td>1000</td>
		</tr>
	</tbody>
</table>
<!-- FTE-Version:1.0.2 -->
"""
And I press button "converttojasper"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I close the current editor
And I switch the current editor to editor "Auftrag"
Then field "baftextbenart" has value 
"""
<html>
<head>
</head>
<body>
	<pre>Artikel	Anzahl	Preis</pre>
	<pre>Motor	1	1000</pre>
</body>
</html>
"""
And I close the current editor


Scenario: Konvertierte Freitext beim Zeigen-Modus wird nicht gespeichert
Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "VIEW" for record "FTEXT"
Then field "baftextbenart" has value  
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I press button "baftextbenart" to open a subeditor for "freitexteditor"
Then field "freitextapi" has value "ja"
Then field "ftexteditierbar" has value "nein"
Then field "freitextinhalt" has value 
"""
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
<!-- FTE-Version:1.0.2 -->
"""
And I save the current editor
And I switch the current editor to editor "Auftrag"
Then field "baftextbenart" has value  
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I close the current editor


Scenario: Freitext aus der Kurtext-Vorlage
Given I open an editor "Kurztext" from table "(Company):(Summary)" with command "NEW" for record ""
And I set field "such" to "TEXTHTML"
And I set field "namebspr" to "Freitext HTML"
And I set field "ftextbspr" to 
"""
<html>
<head>
</head>
<body>
	<pre>Artikel2	Anzahl2	Preis2</pre>
	<pre>Motor2	2	2000</pre>
</body>
</html>
"""
And I save the current editor

Given I open an editor "Kurztext" from table "(Company):(Summary)" with command "NEW" for record ""
And I set field "such" to "TEXT"
And I set field "namebspr" to "Text"
And I set field "ftextbspr" to "Text"
And I save the current editor

Given I open an editor "Kurztext" from table "(Types):(FreeText)" with command "UPDATE" for record "70010"
And I create a new row at the end of the table
And I set field "vorlage" to "TEXTHTML" in row 1
And I create a new row at the end of the table
And I set field "vorlage" to "TEXT" in row 2
And I save the current editor

Given I open an editor "Auftrag" from table "(Sales):(SalesOrder)" with command "UPDATE" for record "FTEXT"
Then field "baftextbenart" has value  
"""
<html>
<head>
</head>
<body>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></pre>
<pre><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span>&#9;<span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></pre>
</body>
</html>

<!---
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
--->
<!-- FTC-Version:1.0.12 -->
<!-- FTE-Version:1.0.2 -->
"""
And I press button "baftextbenart" to open a subeditor for "freitexteditor"
Then field "freitextapi" has value "ja"
Then field "formathtml" has value "ja"
Then field "freitextinhalt" has value 
"""
<table border="0" style="width:30%">
 <tbody>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Artikel</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Anzahl</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Preis</span></td>
  </tr>
  <tr>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">Motor</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1</span></td>
   <td><span style="color:rgb(0, 0, 0);font-family:Arial;font-size:9pt;">1000</span></td>
  </tr>
 </tbody>
</table>
<!-- FTE-Version:1.0.2 -->
"""

And I set field "bufreitextinhaltausvorlage" to "" in rowspec "$,,tbaumtext==Freitext HTML"
Then field "formathtml" has value "ja"
Then field "freitextinhalt" has value 
"""
<html>
<head>
</head>
<body>
	<table border="0" style="width:30%">
		<tbody>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Artikel2</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Anzahl2</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Preis2</span></td>
			</tr>
			<tr>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">Motor2</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">2</span></td>
				<td><span style="font-family: 'DejaVu LGC Sans'; font-size: 9pt; color: rgb(0, 0, 0);">2000</span></td>
			</tr>
		</tbody>
	</table>
</body>
</html>
<!-- OFTC-Version:1.0.12 -->
"""
And I set field "bufreitextinhaltausvorlage" to "" in rowspec "$,,tbaumtext==Text"
Then field "formathtml" has value "nein"
Then field "freitextinhalt" has value "Text"
And I close the current editor
And I switch the current editor to editor "Auftrag"
And I close the current editor
