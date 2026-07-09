<#
.SYNOPSIS
Exports Azure Ultra SSD inventory.
#>

[CmdletBinding()]
param(

    [string]$SubscriptionId,

    [string]$OutputFile = ".\UltraDiskReport.csv"

)

$Results = @()

if ($SubscriptionId) {

    $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId

}
else {

    $Subscriptions = Get-AzSubscription

}

foreach ($Sub in $Subscriptions) {

    Set-AzContext $Sub.Id | Out-Null

    Get-AzDisk |

    Where-Object { $_.Sku.Name -eq "UltraSSD_LRS" } |

    ForEach-Object {

        $Results += [PSCustomObject]@{

            Subscription   = $Sub.Name

            DiskName       = $_.Name

            ResourceGroup  = $_.ResourceGroupName

            Region         = $_.Location

            SizeGB         = $_.DiskSizeGB

            IOPS           = $_.DiskIOPSReadWrite

            ThroughputMBps = $_.DiskMBpsReadWrite

            ManagedBy      = $_.ManagedBy

            State          = $_.DiskState

        }

    }

}

$Results |
Export-Csv $OutputFile -NoTypeInformation

Write-Host "$($Results.Count) Ultra SSD disks exported."