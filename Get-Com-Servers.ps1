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
# - 11/14/2023 creation and first tests

# ==============================================================

# Use the Connection script called "Connect-COM-Secret.ps1"
# This file should be located in the same Directory as this script

# use json file to connect to all sites and retrieve the token and header created 
. ./Connect-COM-Secret.ps1
# Now that we have a token because of successfull COM authentication, we can proceed with REST API calls
# First prepare the environnement
$Region = $Region+"-central1-api."
$Application = "compute"
$ConnectivityEndpoint = "https://$Region$Application.cloud.hpe.com"
$ConnectivityUri = "/compute-ops/v1beta2"
$ConnectivityObject = "/servers"


# Api call to GLR

$request = @{

    Headers = $headers

    StatusCodeVariable = "statusCode"

    Method      = "GET"
    URI = $ConnectivityEndpoint + $ConnectivityUri + $ConnectivityObject
   

}
# Invoke the Api Call
try {
    $result = Invoke-RestMethod @request
}
catch {
    Write-Error "Error making API call to GLDR" -ErrorAction Stop
}


# Show the result in json format
$resultJson = ConvertTo-Json $result
 write-output $resultJson
 # Write the result in a Json formatted file called ComServers.Json
Set-Content -Path './ComServers.json' $resultJson
 # Show some information in more readeable format. as a table

 <#
Write-Host "All sites visbible in GLDR are : " -ForegroundColor Yellow
 $result.items  | Select-Object id , name, networkAddress, type, version,connected | format-table 
#>