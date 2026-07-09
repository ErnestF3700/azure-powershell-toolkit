<#
.SYNOPSIS
    Deploy a new Azure Virtual Machine.

.DESCRIPTION
    Interactive deployment wizard for creating Azure Virtual Machines.


.VERSION
    1.0.0
#>

[CmdletBinding()]
param(
    [switch]$MockMode
)

if (-not $MockMode) {

    if (-not (Get-Module -ListAvailable -Name Az)) {

        throw @"
Azure PowerShell module (Az) is not installed.

Install it with:

Install-Module Az -Scope CurrentUser
"@
    }

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

    if ($MockMode) {

        Write-Host ""
        Write-Host "================ MOCK MODE ================" -ForegroundColor Yellow
        Write-Host "Azure connection is skipped." -ForegroundColor Yellow
        Write-Host "No Azure resources will be created." -ForegroundColor Yellow
        Write-Host "===========================================" -ForegroundColor Yellow
        Write-Host ""

        $subscription = [PSCustomObject]@{
            Name = "Mock Subscription"
            Id   = "00000000-0000-0000-0000-000000000000"
        }

        $resourceGroup = [PSCustomObject]@{
            ResourceGroupName = "RG-MOCK"
            Location          = "westeurope"
        }

        $virtualNetwork = [PSCustomObject]@{
            Name = "VNET-MOCK"
        }

        $subnet = [PSCustomObject]@{
            Name = "Default"
            Id   = "/subscriptions/mock/subnets/default"
        }

        $image = "Windows2022"

        $vmSize = "Standard_B2s"
    }
    else {

        Connect-Azure

        $subscription = Select-Subscription

        $resourceGroup = Select-ResourceGroup

        $virtualNetwork = Select-VNet -ResourceGroup $resourceGroup.ResourceGroupName

        $subnet = Select-Subnet -VirtualNetwork $virtualNetwork

        $image = Select-Image

        $vmSize = Select-VMSize
    }

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

    if ($MockMode) {

        Write-Host ""
        Write-Host "[MOCK] Creating Network Interface..." -ForegroundColor Cyan

        $nic = [PSCustomObject]@{
            Id = "/subscriptions/mock/networkInterfaces/$vmName-NIC"
        }

        Write-Host "[MOCK] Creating Data Disks..." -ForegroundColor Cyan

        $dataDisks = @()

        Write-Host "[MOCK] Creating Virtual Machine..." -ForegroundColor Cyan

        Start-Sleep 2

        Write-Host ""
        Write-Host "========== MOCK DEPLOYMENT ==========" -ForegroundColor Green

        Write-Host "Subscription : $($subscription.Name)"
        Write-Host "ResourceGroup: $($resourceGroup.ResourceGroupName)"
        Write-Host "Location     : $location"
        Write-Host "VNet         : $($virtualNetwork.Name)"
        Write-Host "Subnet       : $($subnet.Name)"
        Write-Host "VM Name      : $vmName"
        Write-Host "Image        : $image"
        Write-Host "VM Size      : $vmSize"

        Write-Host ""
        Write-Host "No Azure resources were created." -ForegroundColor Yellow

    }
    else {

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
    }

    Write-Host ""
    Write-Host "Deployment completed successfully." -ForegroundColor Green
}
catch {

    Write-Host ""
    Write-Host "Deployment failed." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor Yellow
}