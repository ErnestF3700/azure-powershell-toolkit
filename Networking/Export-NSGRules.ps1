[CmdletBinding()]
param(

    [string]$SubscriptionId,

    [string]$OutputFile = ".\NSGRules.csv"

)

$Results = @()

if ($SubscriptionId) {

    Set-AzContext -SubscriptionId $SubscriptionId

    $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId

}
else {

    $Subscriptions = Get-AzSubscription

}

foreach ($Sub in $Subscriptions) {

    Set-AzContext $Sub.Id | Out-Null

    $NSGs = Get-AzNetworkSecurityGroup

    foreach ($NSG in $NSGs) {

        foreach ($Rule in $NSG.SecurityRules) {

            $Results += [PSCustomObject]@{

                Subscription    = $Sub.Name
                NSG             = $NSG.Name
                ResourceGroup   = $NSG.ResourceGroupName

                RuleName        = $Rule.Name

                Direction       = $Rule.Direction

                Access          = $Rule.Access

                Priority        = $Rule.Priority

                Protocol        = $Rule.Protocol

                Source          = $Rule.SourceAddressPrefix

                SourcePort      = $Rule.SourcePortRange

                Destination     = $Rule.DestinationAddressPrefix

                DestinationPort = $Rule.DestinationPortRange

            }

        }

    }

}

$Results | Export-Csv $OutputFile -NoTypeInformation

Write-Host "Rules exported: $($Results.Count)"