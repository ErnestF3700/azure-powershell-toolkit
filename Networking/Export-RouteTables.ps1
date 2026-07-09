[CmdletBinding()]
param(

    [string]$SubscriptionId,

    [string]$OutputFile = ".\RouteTables.csv"

)

$Results = @()

if ($SubscriptionId) {

    Set-AzContext $SubscriptionId

    $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId

}
else {

    $Subscriptions = Get-AzSubscription

}

foreach ($Sub in $Subscriptions) {

    Set-AzContext $Sub.Id | Out-Null

    $Tables = Get-AzRouteTable

    foreach ($Table in $Tables) {

        foreach ($Route in $Table.Routes) {

            $Results += [PSCustomObject]@{

                Subscription  = $Sub.Name

                ResourceGroup = $Table.ResourceGroupName

                RouteTable    = $Table.Name

                RouteName     = $Route.Name

                AddressPrefix = $Route.AddressPrefix

                NextHopType   = $Route.NextHopType

                NextHopIp     = $Route.NextHopIpAddress

            }

        }

    }

}

$Results | Export-Csv $OutputFile -NoTypeInformation

Write-Host "Routes exported: $($Results.Count)"