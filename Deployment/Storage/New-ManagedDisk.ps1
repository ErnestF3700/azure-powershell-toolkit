<#
.SYNOPSIS
Creates a managed disk.
#>

Connect-AzAccount | Out-Null

$resourceGroups = Get-AzResourceGroup

for ($i = 0; $i -lt $resourceGroups.Count; $i++) {

    Write-Host "$($i+1). $($resourceGroups[$i].ResourceGroupName)"
}

$choice = Read-Host "Select Resource Group"

$rg = $resourceGroups[$choice - 1]

$diskName = Read-Host "Disk Name"

$diskSize = Read-Host "Disk Size (GB)"

$sku = Read-Host "Disk SKU (StandardSSD_LRS / Premium_LRS)"

$config = New-AzDiskConfig `
    -Location $rg.Location `
    -CreateOption Empty `
    -DiskSizeGB $diskSize `
    -SkuName $sku

New-AzDisk `
    -ResourceGroupName $rg.ResourceGroupName `
    -DiskName $diskName `
    -Disk $config

Write-Host ""
Write-Host "Managed Disk created successfully." -ForegroundColor Green