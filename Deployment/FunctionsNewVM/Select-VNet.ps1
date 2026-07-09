function Select-VNet {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ResourceGroup
    )

    Write-Host ""
    Write-Host "Available Virtual Networks" -ForegroundColor Cyan
    Write-Host "--------------------------------"

    $vnets = Get-AzVirtualNetwork -ResourceGroupName $ResourceGroup |
    Sort-Object Name

    if ($vnets.Count -eq 0) {
        throw "No Virtual Networks found in Resource Group '$ResourceGroup'."
    }

    for ($i = 0; $i -lt $vnets.Count; $i++) {
        Write-Host ("[{0}] {1}" -f ($i + 1), $vnets[$i].Name)
    }

    do {
        $choice = Read-Host "`nSelect Virtual Network"
    } until (
        [int]::TryParse($choice, [ref]$null) -and
        $choice -ge 1 -and
        $choice -le $vnets.Count
    )

    return $vnets[$choice - 1]
}