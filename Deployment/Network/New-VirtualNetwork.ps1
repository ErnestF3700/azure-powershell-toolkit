<#
.SYNOPSIS
Creates a new Azure Virtual Network.
#>

Connect-AzAccount | Out-Null

$rg = Read-Host "Resource Group"
$location = Read-Host "Location (e.g. westeurope)"
$vnetName = Read-Host "Virtual Network Name"

$addressSpace = Read-Host "Address Space (10.0.0.0/16)"
$subnetName = Read-Host "Subnet Name"
$subnetPrefix = Read-Host "Subnet Prefix (10.0.1.0/24)"

$subnet = New-AzVirtualNetworkSubnetConfig `
    -Name $subnetName `
    -AddressPrefix $subnetPrefix

New-AzVirtualNetwork `
    -ResourceGroupName $rg `
    -Location $location `
    -Name $vnetName `
    -AddressPrefix $addressSpace `
    -Subnet $subnet

Write-Host "Virtual Network created." -ForegroundColor Green