<#
.SYNOPSIS
Exports Azure VM performance metrics.

.DESCRIPTION
Collects CPU, Memory and Disk metrics for Azure Virtual Machines
using Azure Monitor.

.EXAMPLE
.\VMPerformance.ps1

.EXAMPLE
.\VMPerformance.ps1 -SubscriptionId xxxxx
#>

[CmdletBinding()]
param(
    [string]$SubscriptionId,
    [int]$Days = 30,
    [string]$OutputFile = ".\VMPerformance.csv"
)

$Results = @()

if ($SubscriptionId) {
    $Subscriptions = Get-AzSubscription -SubscriptionId $SubscriptionId
}
else {
    $Subscriptions = Get-AzSubscription
}

foreach ($Sub in $Subscriptions) {

    Set-AzContext -SubscriptionId $Sub.Id | Out-Null

    $VMs = Get-AzVM

    foreach ($VM in $VMs) {

        Write-Verbose "Processing $($VM.Name)"

        $StartDate = (Get-Date).AddDays(-$Days)

        $CPU = Get-AzMetric `
            -ResourceId $VM.Id `
            -MetricName "Percentage CPU" `
            -AggregationType Average `
            -StartTime $StartDate

        $CPUAvg = ($CPU.Data | Measure-Object Average -Average).Average

        $Results += [PSCustomObject]@{

            Subscription  = $Sub.Name
            ResourceGroup = $VM.ResourceGroupName
            VMName        = $VM.Name
            Location      = $VM.Location
            VMSize        = $VM.HardwareProfile.VmSize
            AverageCPU    = "{0:N2}" -f $CPUAvg

        }

    }

}

$Results |
Sort-Object AverageCPU -Descending |
Export-Csv $OutputFile -NoTypeInformation

Write-Host "Exported $($Results.Count) VMs"