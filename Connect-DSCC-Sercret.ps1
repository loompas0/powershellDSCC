<#
Legal Disclaimer
This script is an example script and is not supported by any means.
The author further disclaim all implied warranties including, 
without limitation, any implied warranties of merchantability 
or of fitness for a particular purpose.
In no event shall  its authors or anyone else involved in 
the creation, production or delivery of the scripts be liable for 
any damages whatsoever 
(including, without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) arising out of the use of or the inability 
to use the sample scripts or documentation, 
even if the author  has been advised of the possibility of such damages. 
The entire risk arising out of the use or performance of the sample scripts 
and documentation remains with you.
#>

<#
The Author is Loompas0 who is a pseudo.
The source site of the code couldbe https://github.com/loompas0/ 
if you are explicitely or implicitely authorized to access to it.
#>

# History 
# - 09/21/2023 creation and first tests

# Read file for credentials .json
$ApiFile = Get-Content -path .\ApiUser.json -Raw | ConvertFrom-Json -ErrorAction Stop

$DsccRegion = $ApiFile.DsccRegion
$DsccClientID = $ApiFile.DsccClientID
$DsccClientSecret = $ApiFile.DsccClientSecret

Write-Host "The region is : $DsccRegion" -ForegroundColor Magenta
Write-Host "The Client ID is : $DsccClientID" -ForegroundColor Magenta

#lets get connect to DSCC in order to receive a Token
$Token = Connect-DSCC -Client_Id $DsccClientID -Client_Secret $DsccClientSecret -GreenlakeType $DsccRegion -AutoRenew
Write-Host "The Token is : " -ForegroundColor DarkCyan
Write-Host $Token.Access_Token -ForegroundColor Cyan