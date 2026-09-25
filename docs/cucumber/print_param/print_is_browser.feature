#@persistent
Feature: Testen Layout IS.BROSER mit verschiedenen Infosystemen
Background:
Given I set the fake date to "02.01.1995"

Scenario Outline:

Given I open the infosystem "<infosystem>"
And I press button "bstart"
And I print layout "IS.BROWSER" with filename "win/tmp/<infosystem>.html"
And file "win/tmp/<infosystem>.html" exists
Then file "win/tmp/<infosystem>.html" contains text "/browser/browser.css"
And I close the current editor

Examples:
| row | infosystem |
| 001 | LKU        |
| 002 | LOP        |
| 003 | RAL        |
| 004 | PRINTQUEUE |
