function Show-Summary {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        [string]$VMName,

        [Parameter(Mandatory)]
        [string]$ResourceGroup,

        [Parameter(Mandatory)]
        [string]$Location,

        [Parameter(Mandatory)]
        [string]$VirtualNetwork,

        [Parameter(Mandatory)]
        [string]$Subnet,

        [Parameter(Mandatory)]
        [string]$Image,

        [Parameter(Mandatory)]
        [string]$VMSize

    )

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan
    Write-Host "          Deployment Summary"
    Write-Host "==========================================" -ForegroundColor Cyan

    Write-Host ("VM Name          : {0}" -f $VMName)
    Write-Host ("Resource Group   : {0}" -f $ResourceGroup)
    Write-Host ("Location         : {0}" -f $Location)
    Write-Host ("Virtual Network  : {0}" -f $VirtualNetwork)
    Write-Host ("Subnet           : {0}" -f $Subnet)
    Write-Host ("Operating System : {0}" -f $Image)
    Write-Host ("VM Size          : {0}" -f $VMSize)

    Write-Host ""
    Write-Host "==========================================" -ForegroundColor Cyan

    $answer = Read-Host "Continue deployment? (Y/N)"

    if ($answer.ToUpper() -ne "Y") {
        throw "Deployment cancelled by user."
    }
}