<#
.SYNOPSIS
Enables Azure Disk Encryption on a Virtual Machine.
#>

Connect-AzAccount | Out-Null

$vms = Get-AzVM

for ($i = 0; $i -lt $vms.Count; $i++) {

    Write-Host "$($i+1). $($vms[$i].Name)"
}

$choice = Read-Host "Select Virtual Machine"

$vm = $vms[$choice - 1]

$keyVaults = Get-AzKeyVault

for ($i = 0; $i -lt $keyVaults.Count; $i++) {

    Write-Host "$($i+1). $($keyVaults[$i].VaultName)"
}

$choice = Read-Host "Select Key Vault"

$kv = $keyVaults[$choice - 1]

$keyName = Read-Host "Encryption Key Name"

$key = Add-AzKeyVaultKey `
    -VaultName $kv.VaultName `
    -Name $keyName `
    -Destination Software

Write-Host ""
Write-Host "Enabling Azure Disk Encryption..."

Set-AzVMDiskEncryptionExtension `
    -ResourceGroupName $vm.ResourceGroupName `
    -VMName $vm.Name `
    -DiskEncryptionKeyVaultUrl $kv.VaultUri `
    -DiskEncryptionKeyVaultId $kv.ResourceId `
    -KeyEncryptionKeyUrl $key.Key.Kid `
    -KeyEncryptionKeyVaultId $kv.ResourceId `
    -VolumeType All `
    -Force

Write-Host ""
Write-Host "Disk encryption enabled." -ForegroundColor Green

Get-AzVMDiskEncryptionStatus `
    -ResourceGroupName $vm.ResourceGroupName `
    -VMName $vm.Name
    