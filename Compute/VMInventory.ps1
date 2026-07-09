<#
.SYNOPSIS
Exports Azure VM Inventory.

.DESCRIPTION
Creates a complete inventory of Azure Virtual Machines.

#>

[CmdletBinding()]
param(

    [string]$SubscriptionId,

    [string]$OutputFile = ".\VMInventory.csv"

)

$Inventory = @()

if ($SubscriptionId) {

    $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId

}
else {

    $Subscriptions = Get-AzSubscription

}

foreach ($Sub in $Subscriptions) {

    Set-AzContext $Sub.Id | Out-Null

    $VMs = Get-AzVM -Status

    foreach ($VM in $VMs) {

        $NIC = Get-AzNetworkInterface |
        Where-Object { $_.Id -contains $VM.NetworkProfile.NetworkInterfaces.Id }

        $PrivateIP = ($NIC.IpConfigurations.PrivateIpAddress) -join ","

        $PublicIP = ""

        foreach ($config in $NIC.IpConfigurations) {

            if ($config.PublicIpAddress) {

                $pip = Get-AzPublicIpAddress -ResourceId $config.PublicIpAddress.Id

                $PublicIP += "$($pip.IpAddress) "

            }

        }

        $Inventory += [PSCustomObject]@{

            Subscription     = $Sub.Name

            ResourceGroup    = $VM.ResourceGroupName

            VMName           = $VM.Name

            Region           = $VM.Location

            PowerState       = ($VM.Statuses |
                Where-Object Code -like "PowerState/*").DisplayStatus

            VMSize           = $VM.HardwareProfile.VmSize

            OSType           = $VM.StorageProfile.OsDisk.OsType

            PrivateIP        = $PrivateIP

            PublicIP         = $PublicIP.Trim()

            OSDisk           = $VM.StorageProfile.OsDisk.Name

            DataDisks        = ($VM.StorageProfile.DataDisks.Name -join ",")

            AvailabilityZone = ($VM.Zones -join ",")

            Tags             = ($VM.Tags.GetEnumerator() |
                ForEach-Object { "$($_.Key)=$($_.Value)" } -join ";")

        }

    }

}

$Inventory |

Sort-Object Subscription, ResourceGroup, VMName |

Export-Csv $OutputFile -NoTypeInformation

Write-Host "Inventory exported: $($Inventory.Count) VMs"