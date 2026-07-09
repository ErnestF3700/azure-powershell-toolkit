<#
.SYNOPSIS
Finds unused Azure Public IP addresses.

.DESCRIPTION
Searches for Public IP resources that are not associated
with any Azure resource.

#>

[CmdletBinding()]
param(
    [string]$SubscriptionId,
    [string]$OutputFile = ".\UnusedPublicIPs.csv"
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

    Get-AzPublicIpAddress |
    Where-Object { -not $_.IpConfiguration } |
    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription     = $Sub.Name
            ResourceGroup    = $_.ResourceGroupName
            PublicIPName     = $_.Name
            IPAddress        = $_.IpAddress
            AllocationMethod = $_.PublicIpAllocationMethod
            SKU              = $_.Sku.Name
            Region           = $_.Location

        }

    }

}

$Results |
Export-Csv $OutputFile -NoTypeInformation

Write-Host "Found $($Results.Count) unused Public IPs."