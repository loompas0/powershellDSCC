# Display all SystemId 

Write-Host "All system to choose from are"
Get-DSCCStorageSystem -DeviceType device-type1 | Format-Table name, id

#create the new volume
$SystemId = Read-Host -Prompt "Copy and paste one of the ID"
$VolumeName  = Read-Host -Prompt 'Input the Volume name'
$SizeMib = Read-Host -Prompt "Enter the size in MiB"
$SizeInt =[int32]$SizeMib
$CpgName = (Get-DSCCPool -SystemId $SystemId).name
New-DSCCVolumeDeviceType1 -SystemId $SystemId -name $VolumeName -sizeMiB $SizeInt -userCpg $CpgName
<#
#display the volume created
$VolumeId = (Get-DSCCVolume -SystemId $SystemId).Volumeid |findstr $VolumeName
Get-DSCCVolume -SystemId $SystemId -VolumeId $VolumeId | Format-Table name, size, de-dup, compression
#>