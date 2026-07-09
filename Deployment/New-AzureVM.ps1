<#
.SYNOPSIS
    Deploy a new Azure Virtual Machine.

.DESCRIPTION
    Interactive deployment wizard for creating Azure Virtual Machines.


.VERSION
    1.0.0
#>


if (-not (Get-Module -ListAvailable -Name Az)) {
    Write-Host "Azure PowerShell module not installed." -ForegroundColor Red
    Write-Host "Run: Install-Module Az -Scope CurrentUser"
    return
}


# Load all functions
Clear-Host

Write-Host ""
Write-Host "============================================" -ForegroundColor Cyan
Write-Host "        Azure VM Deployment Wizard"
Write-Host "============================================" -ForegroundColor Cyan
Write-Host ""


$FunctionPath = Join-Path $PSScriptRoot "FunctionsNewVM"

if (-not (Test-Path $FunctionPath)) {
    throw "Functions folder not found."
}

Get-ChildItem -Path $FunctionPath -Filter *.ps1 | ForEach-Object {

    Write-Verbose "Loading $($_.Name)"

    . $_.FullName
}

try {

    Connect-Azure

    $subscription = Select-Subscription

    $resourceGroup = Select-ResourceGroup

    $virtualNetwork = Select-VNet -ResourceGroup $resourceGroup.ResourceGroupName

    $subnet = Select-Subnet -VirtualNetwork $virtualNetwork

    $image = Select-Image

    $vmSize = Select-VMSize

    $vmName = Read-Host "Virtual Machine Name"

    $location = $resourceGroup.Location

    Show-Summary `
        -VMName $vmName `
        -ResourceGroup $resourceGroup.ResourceGroupName `
        -Location $location `
        -VirtualNetwork $virtualNetwork.Name `
        -Subnet $subnet.Name `
        -Image $image `
        -VMSize $vmSize

    $nic = New-AzureNetworkInterface `
        -ResourceGroup $resourceGroup.ResourceGroupName `
        -Location $location `
        -NicName "$vmName-NIC" `
        -SubnetId $subnet.Id

    $dataDisks = New-AzureDataDisks `
        -ResourceGroup $resourceGroup.ResourceGroupName `
        -Location $location

    New-AzureVirtualMachine `
        -ResourceGroup $resourceGroup.ResourceGroupName `
        -Location $location `
        -VMName $vmName `
        -VMSize $vmSize `
        -Image $image `
        -Nic $nic

    Write-Host ""
    Write-Host "Deployment completed successfully." -ForegroundColor Green
}
catch {

    Write-Host ""
    Write-Host "Deployment failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}