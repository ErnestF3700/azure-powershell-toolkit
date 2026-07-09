<#
.SYNOPSIS
Creates a Public IP.
#>

Connect-AzAccount | Out-Null

$rg = Read-Host "Resource Group"

$location = Read-Host "Location"

$name = Read-Host "Public IP Name"

New-AzPublicIpAddress `
    -Name $name `
    -ResourceGroupName $rg `
    -Location $location `
    -AllocationMethod Static `
    -Sku Standard

Write-Host "Public IP created." -ForegroundColor Green