<#
.SYNOPSIS
Creates an Azure Key Vault.
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

$keyVaultName = Read-Host "Key Vault Name"

New-AzKeyVault `
    -VaultName $keyVaultName `
    -ResourceGroupName $rg.ResourceGroupName `
    -Location $rg.Location `
    -Sku Standard `
    -EnabledForDeployment `
    -EnabledForTemplateDeployment `
    -EnabledForDiskEncryption

Write-Host ""
Write-Host "Key Vault created successfully." -ForegroundColor Green