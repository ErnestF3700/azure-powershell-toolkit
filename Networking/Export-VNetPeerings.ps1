<#
.SYNOPSIS
Exports Azure Virtual Network Peerings.

.DESCRIPTION
Enumerates all subscriptions (or selected subscription) and exports
Virtual Network Peering configuration.

.EXAMPLE
.\Export-VNetPeerings.ps1

.EXAMPLE
.\Export-VNetPeerings.ps1 -SubscriptionId xxxxxxxx

#>

[CmdletBinding()]
param(
    [string]$SubscriptionId,

    [string]$OutputFile = ".\VNetPeerings.csv"
)

$Results = @()

try {

    if ($SubscriptionId) {
        Set-AzContext -SubscriptionId $SubscriptionId | Out-Null
        $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId
    }
    else {
        $Tenant = (Get-AzContext).Tenant.Id
        $Subscriptions = Get-AzSubscription -TenantId $Tenant
    }

    foreach ($Sub in $Subscriptions) {

        Write-Verbose "Processing subscription $($Sub.Name)"

        Set-AzContext -SubscriptionId $Sub.Id | Out-Null

        $VNets = Get-AzVirtualNetwork

        foreach ($Vnet in $VNets) {

            foreach ($Peering in $Vnet.VirtualNetworkPeerings) {

                $Results += [PSCustomObject]@{

                    Subscription          = $Sub.Name
                    ResourceGroup         = $Vnet.ResourceGroupName
                    VNet                  = $Vnet.Name
                    Region                = $Vnet.Location
                    Peering               = $Peering.Name
                    RemoteVNet            = $Peering.RemoteVirtualNetwork.Id
                    State                 = $Peering.PeeringState
                    AllowForwardedTraffic = $Peering.AllowForwardedTraffic
                    AllowGatewayTransit   = $Peering.AllowGatewayTransit
                    UseRemoteGateways     = $Peering.UseRemoteGateways

                }

            }

        }

    }

    $Results | Export-Csv $OutputFile -NoTypeInformation

    Write-Host ""
    Write-Host "Exported $($Results.Count) peerings"
    Write-Host "File: $OutputFile"

}
catch {

    Write-Error $_

}