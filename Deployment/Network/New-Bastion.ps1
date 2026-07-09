<#
.SYNOPSIS
Creates Azure Bastion.
#>

Connect-AzAccount | Out-Null

$rg = Read-Host "Resource Group"

$vnetName = Read-Host "Virtual Network"

$publicIP = Read-Host "Public IP Name"

$bastionName = Read-Host "Bastion Name"

$vnet = Get-AzVirtualNetwork `
    -Name $vnetName `
    -ResourceGroupName $rg

$pip = Get-AzPublicIpAddress `
    -Name $publicIP `
    -ResourceGroupName $rg

New-AzBastion `
    -ResourceGroupName $rg `
    -Name $bastionName `
    -PublicIpAddress $pip `
    -VirtualNetwork $vnet

Write-Host "Azure Bastion created." -ForegroundColor Green
