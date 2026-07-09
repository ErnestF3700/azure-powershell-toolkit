<#
.SYNOPSIS
Creates a new Azure Storage Account.
#>

Connect-AzAccount | Out-Null

$subscriptions = Get-AzSubscription

for ($i = 0; $i -lt $subscriptions.Count; $i++) {
    Write-Host "$($i+1). $($subscriptions[$i].Name)"
}

$choice = Read-Host "Select Subscription"

Set-AzContext -SubscriptionId $subscriptions[$choice - 1].Id | Out-Null

$resourceGroups = Get-AzResourceGroup

for ($i = 0; $i -lt $resourceGroups.Count; $i++) {
    Write-Host "$($i+1). $($resourceGroups[$i].ResourceGroupName)"
}

$choice = Read-Host "Select Resource Group"

$rg = $resourceGroups[$choice - 1]

$name = Read-Host "Storage Account Name"

$sku = Read-Host "SKU (Standard_LRS / Standard_ZRS / Premium_LRS)"

New-AzStorageAccount `
    -ResourceGroupName $rg.ResourceGroupName `
    -Name $name `
    -Location $rg.Location `
    -SkuName $sku `
    -Kind StorageV2

Write-Host ""
Write-Host "Storage Account created successfully." -ForegroundColor Green