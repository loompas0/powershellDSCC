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
# - 20/10/2023 creation and first tests

# ==============================================================

# Use the Connection script called "Connect-DSCC-Secret.ps1"
# This file should be located in the same Directory as this script

# use json file to connect to all sites
. ./Connect-DSCC-Secret.ps1
# Now that we have a token because of successfull DSCC authentication, we can proceed with GLDR REST API calls
# First prepare the environnement
$GldrApiBase = "/disaster-recovery/v1beta1/"
$GldrUriBase = $Base+$GldrApiBase # $Base is a global variable used in the powershell module # ConnectDscc
$Auth = $Token.Access_Token

# Call GetGLDRAllsites and use the json  file GLDRAllsites.json

# . ./GetGLDRAllsites.ps1

# Function to print a table based on Json File and select a site to delete


function Select-GldrSites 
{
    param (
        $FileName
    )
$Allsites = Get-Content -Path $FileName | ConvertFrom-Json
$Allsites.items  | Select-Object id , name, networkAddress, type, version,connected | format-table 

    $i = 1
    ForEach ($Line in $Allsites.items)
    {
         $Line.items  | Select-Object id , name, networkAddress, type, version,connected | format-table 
       Write-Host "$i ) "
        $i++
    }

}

Select-GldrSites ("./GLDRAllsites.json")

# #read the serial number from ZVM management GUI
# $SerialNumber = Read-Host -Prompt "Please Enter the serial Number copied from ZVM You want to attach"

# $Headers = @{
#     "Content-Type"  = "application/json"
#     Authorization = "Bearer $Auth"
#     Accept = "application/json"
# }
# $Body = 
# "{
# `"serialNumber`": `"{$SerialNumber}`"
# }"
# $UriApi = $GldrUriBase + "virtual-sites"
# # Api call to GLDR
# try {
#     $result = Invoke-RestMethod -Uri $UriApi  -Headers $Headers -Method Post -Body $Body 
# }
# catch {
#     Write-Error "Error making API call to GLDR" -ErrorAction Stop
# }

# # Show the result in json format
# $resultJson = ConvertTo-Json $result
#  write-output $resultJson
# <#
#  # Write the result in a Json formatted file calles GLDRAllSites.Json
# Set-Content -Path './GLDRAllsites.json' $resultJson
#  # Show some information in more readeable format. as a table
# Write-Host "All sites visbible in GLDR are : " -ForegroundColor Yellow
#  $result.items  | Select-Object id , name, networkAddress, type, version,connected | format-table 
#  #>