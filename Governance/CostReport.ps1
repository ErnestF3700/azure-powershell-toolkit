<#
.SYNOPSIS
Generates a basic Azure cost optimization report.

.DESCRIPTION
Collects commonly unused Azure resources that may generate unnecessary costs.

Current checks:

- Unattached managed disks
- Unused Public IPs
- Empty Network Security Groups
- Empty Route Tables

#>

[CmdletBinding()]
param(
    [string]$SubscriptionId,
    [string]$OutputFile = ".\AzureCostReport.csv"
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

    # Unattached Disks

    Get-AzDisk |
    Where-Object { -not $_.ManagedBy } |
    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription   = $Sub.Name
            ResourceType   = "Managed Disk"
            ResourceName   = $_.Name
            ResourceGroup  = $_.ResourceGroupName
            Recommendation = "Disk is not attached to any VM."

        }

    }

    # Public IP

    Get-AzPublicIpAddress |
    Where-Object { -not $_.IpConfiguration } |
    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription   = $Sub.Name
            ResourceType   = "Public IP"
            ResourceName   = $_.Name
            ResourceGroup  = $_.ResourceGroupName
            Recommendation = "Public IP is not associated."

        }

    }

    # Empty NSG

    Get-AzNetworkSecurityGroup |
    Where-Object { $_.NetworkInterfaces.Count -eq 0 -and $_.Subnets.Count -eq 0 } |
    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription   = $Sub.Name
            ResourceType   = "Network Security Group"
            ResourceName   = $_.Name
            ResourceGroup  = $_.ResourceGroupName
            Recommendation = "NSG is not attached."

        }

    }

    # Empty Route Table

    Get-AzRouteTable |
    Where-Object { $_.Subnets.Count -eq 0 } |
    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription   = $Sub.Name
            ResourceType   = "Route Table"
            ResourceName   = $_.Name
            ResourceGroup  = $_.ResourceGroupName
            Recommendation = "Route Table is not associated."

        }

    }

}

$Results |
Sort-Object Subscription, ResourceType |
Export-Csv $OutputFile -NoTypeInformation

Write-Host ""
Write-Host "Azure Cost Report completed."
Write-Host "Potential cost optimization items: $($Results.Count)"
Write-Host "Output: $OutputFile"