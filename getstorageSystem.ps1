
function Invoke-DSCCRestMethod {  
    Param   (   $UriAdd,
        $Body = '',
        $Method = 'Get',
        $WhatIfBoolean = $false
    )
    Process {
        Invoke-DSCCAutoReconnect
        $MyURI = $BaseURI + $UriAdd
        Clear-Variable -Name InvokeReturnData -ErrorAction SilentlyContinue
        if ( $WhatIfBoolean ) {
            invoke-RestMethodWhatIf -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
        }
        else {
            Write-Verbose "About to make rest call to URL $MyUri."
            try {
                $InvokeReturnData = Invoke-RestMethod -Uri $MyUri -Method $Method -Headers $MyHeaders -Body $Body -ContentType 'application/json'
            }
            catch {
                ThrowHTTPError -ErrorResponse $_ 
                return
            }
            if (($InvokeReturnData).items) {
                $InvokeReturnData = ($InvokeReturnData).items
            }
            if (($InvokeReturnData).Total -eq 0) {
                Write-Verbose 'The call succeeded however zero items were returned'
                $InvokeReturnData = ''
            }
        }   
        return $InvokeReturnData
    }
}
function Get-DsccStorageSystem { 
    [CmdletBinding(DefaultParameterSetName = 'BySystemId')]
    param (
        [Parameter(ParameterSetName = 'BySystemId')]
        [alias('id')]
        [string]$SystemId,

        [parameter(helpMessage = 'The acceptable values are device-type1,  device-type2, device-type4.')]
        [validateset('device-type1', 'device-type2', 'device-type4')]  
        [string]$DeviceType
    )
    begin {    
    }
    process {
        if ( $DeviceType ) { 
            $DevType = $DeviceType
        }
        else {
            $DevType = @( 'device-type1', 'device-type2', "device-type4")
        }

        $SystemCollection = @()
        foreach ( $ThisDeviceType in $DevType ) {
            $UriAdd = "storage-systems/$ThisDeviceType"
            $Response = Invoke-DsccRestMethod -UriAdd $UriAdd -method Get -WhatIf:$WhatIfPreference
            if ($PSBoundParameters.ContainsKey('SystemId') -or $PSBoundParameters.ContainsKey('SystemName')) {
                $Response = $Response | Where-Object id -In $SystemId
            }
            $Returndata = Invoke-RepackageObjectWithType -RawObject $Response -ObjectName 'StorageSystem.Combined'
            $SystemCollection += $Returndata    
        }
        Write-Output $SystemCollection
    } #end process

    end {}
}
Get-DsccStorageSystem