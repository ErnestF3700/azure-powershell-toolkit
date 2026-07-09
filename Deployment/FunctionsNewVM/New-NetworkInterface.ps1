function New-AzureNetworkInterface {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ResourceGroup,

        [Parameter(Mandatory)]
        [string]$Location,

        [Parameter(Mandatory)]
        [string]$NicName,

        [Parameter(Mandatory)]
        [string]$SubnetId
    )

    Write-Host ""
    Write-Host "Creating Network Interface..." -ForegroundColor Cyan

    $nic = New-AzNetworkInterface `
        -Name $NicName `
        -ResourceGroupName $ResourceGroup `
        -Location $Location `
        -SubnetId $SubnetId

    Write-Host "NIC created." -ForegroundColor Green

    return $nic
}