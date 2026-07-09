function New-AzureVirtualMachine {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$ResourceGroup,

        [Parameter(Mandatory)]
        [string]$Location,

        [Parameter(Mandatory)]
        [string]$VMName,

        [Parameter(Mandatory)]
        [string]$VMSize,

        [Parameter(Mandatory)]
        [string]$Image,

        [Parameter(Mandatory)]
        [object]$Nic
    )

    Write-Host ""
    Write-Host "Creating virtual machine..." -ForegroundColor Cyan

    $credential = Get-Credential

    $vm = New-AzVMConfig `
        -VMName $VMName `
        -VMSize $VMSize

    if ($Image -like "Windows*") {

        $vm = Set-AzVMOperatingSystem `
            -VM $vm `
            -Windows `
            -ComputerName $VMName `
            -Credential $credential `
            -ProvisionVMAgent `
            -EnableAutoUpdate

    }
    else {

        $vm = Set-AzVMOperatingSystem `
            -VM $vm `
            -Linux `
            -ComputerName $VMName `
            -Credential $credential
    }

    $vm = Add-AzVMNetworkInterface `
        -VM $vm `
        -Id $Nic.Id

    switch ($Image) {

        "Windows2025" {
            $publisher = "MicrosoftWindowsServer"
            $offer = "WindowsServer"
            $sku = "2025-datacenter-g2"
        }

        "Windows2022" {
            $publisher = "MicrosoftWindowsServer"
            $offer = "WindowsServer"
            $sku = "2022-datacenter-g2"
        }

        "Ubuntu2404" {
            $publisher = "Canonical"
            $offer = "ubuntu-24_04-lts"
            $sku = "server"
        }

        "Ubuntu2204" {
            $publisher = "Canonical"
            $offer = "0001-com-ubuntu-server-jammy"
            $sku = "22_04-lts-gen2"
        }

        default {
            throw "Unsupported image."
        }
    }

    $vm = Set-AzVMSourceImage `
        -VM $vm `
        -PublisherName $publisher `
        -Offer $offer `
        -Skus $sku `
        -Version latest

    New-AzVM `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -VM $vm

    Write-Host ""
    Write-Host "Virtual Machine created successfully." -ForegroundColor Green
}