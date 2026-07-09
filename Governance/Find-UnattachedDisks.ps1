<#
.SYNOPSIS
Finds unattached managed disks in Azure.

.DESCRIPTION
Searches all subscriptions (or a selected subscription) for managed disks
that are not attached to any virtual machine.

.EXAMPLE
.\Find-UnattachedDisks.ps1

.EXAMPLE
.\Find-UnattachedDisks.ps1 -SubscriptionId <subscription-id>
#>

[CmdletBinding()]
param(
    [string]$SubscriptionId,
    [string]$OutputFile = ".\UnattachedDisks.csv"
)

$Results = @()

$Subscriptions = if ($SubscriptionId) {
    Get-AzSubscription -SubscriptionId $SubscriptionId
}
else {
    Get-AzSubscription
}

foreach ($Sub in $Subscriptions) {

    Set-AzContext -SubscriptionId $Sub.Id | Out-Null

    Get-AzDisk |
    Where-Object { -not $_.ManagedBy } |
    ForEach-Object {

        $Results += [PSCustomObject]@{
            Subscription  = $Sub.Name
            ResourceGroup = $_.ResourceGroupName
            DiskName      = $_.Name
            Region        = $_.Location
            SizeGB        = $_.DiskSizeGB
            SKU           = $_.Sku.Name
            State         = $_.DiskState
            Created       = $_.TimeCreated
        }

    }

}

$Results |
Sort-Object Subscription, ResourceGroup |
Export-Csv $OutputFile -NoTypeInformation

Write-Host "Found $($Results.Count) unattached disks."