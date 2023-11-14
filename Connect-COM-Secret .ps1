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

<#This script has been tested on a Windows environment#>

# History 
# - 08/11/2023 creation and first tests
# - 14/11/2023 take input from https://github.com/jullienl/HPE-Compute-Ops-Management to create a more suitable connection pattern
# ******************************************

# ==============================================================
# Read file for credentials from a json file
# this File contains information created before in the API section of HPE Greenlake
# at https://common.cloud.hpe.com/manage-account/api 
# using create credential button and selecting DSCC + region app
# In this example it is ApiUser.json located in the same Directory 
# the sructure of the file is 
<#
{
    "DsccRegion": "Exepected Greenlake region of your account  like EU for Europe , or AP for APC or CA for Central US US for WEST US  ",
    "DsccApiName": "This is a credential name given in the portal like for example PowerShellAccess",
    "DsccClientID": "It is the client ID",
    "DsccClientSecret": "This is the client secret you saved when creatng the api credential in Greenlake "
}
#>

$ApiFile = Get-Content -path .\ApiUser.json -Raw | ConvertFrom-Json -ErrorAction Stop

$Region = $ApiFile.DsccRegion
$ClientID = $ApiFile.DsccClientID
$ClientSecret = $ApiFile.DsccClientSecret

# Print Region and client ID Just for verification that the file was read correctly
Write-Host "The region is : $Region" -ForegroundColor Magenta
Write-Host "The Client ID is : $ClientID" -ForegroundColor Magenta

#lets get connect to DSCC in order to receive a Token

# Headers creation
$headers = @{} 
$headers["Content-Type"] = "application/x-www-form-urlencoded"

# Payload creation
$body = "grant_type=client_credentials&client_id=" + $ClientID + "&client_secret=" + $ClientSecret


try {
  $response = Invoke-webrequest "https://sso.common.cloud.hpe.com/as/token.oauth2" -Method POST -Headers $headers -Body $body
}
catch {
  write-host "Authentication error !" $error[0].Exception.Message -ForegroundColor Red
}


# Capturing API Access Token
$AccessToken = ($response.Content  | Convertfrom-Json).access_token

# Headers creation
$headers = @{} 
$headers["Authorization"] = "Bearer $AccessToken"


# Print the token could be usefull to test some direct rest api calls
Write-Host "The Token is : " -ForegroundColor DarkCyan
Write-Host $AccessToken -ForegroundColor Cyan

# get the Apiversion for COM