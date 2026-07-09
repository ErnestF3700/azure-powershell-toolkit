<#
.SYNOPSIS
Starts an Azure Virtual Machine.
#>

Connect-AzAccount | Out-Null

$subscription = Get-AzSubscription

for ($i = 0; $i -lt $subscription.Count; $i++) {
    Write-Host "$($i+1). $($subscription[$i].Name)"
}

$choice = Read-Host "Select Subscription"

Set-AzContext -SubscriptionId $subscription[$choice - 1].Id | Out-Null

$vm = Get-AzVM

for ($i = 0; $i -lt $vm.Count; $i++) {
    Write-Host "$($i+1). $($vm[$i].Name) ($($vm[$i].ResourceGroupName))"
}

$choice = Read-Host "Select VM"

$selected = $vm[$choice - 1]

Start-AzVM `
    -ResourceGroupName $selected.ResourceGroupName `
    -Name $selected.Name

Write-Host ""
Write-Host "VM started successfully." -ForegroundColor Green