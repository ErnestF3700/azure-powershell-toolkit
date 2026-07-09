<#
.SYNOPSIS
Creates an Azure Network Security Group.
#>

Connect-AzAccount | Out-Null

$rg = Read-Host "Resource Group"
$location = Read-Host "Location"
$nsgName = Read-Host "NSG Name"

New-AzNetworkSecurityGroup `
    -Name $nsgName `
    -ResourceGroupName $rg `
    -Location $location

Write-Host "NSG created." -ForegroundColor Green