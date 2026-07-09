function Select-Subnet {

    [CmdletBinding()]
    param(

        [Parameter(Mandatory)]
        $VirtualNetwork

    )

    Write-Host ""
    Write-Host "Available Subnets" -ForegroundColor Cyan
    Write-Host "--------------------------------"

    $subnets = $VirtualNetwork.Subnets

    for ($i = 0; $i -lt $subnets.Count; $i++) {

        Write-Host ("[{0}] {1}" -f ($i + 1), $subnets[$i].Name)
    }

    do {

        $choice = Read-Host "`nSelect Subnet"

    } until ([int]$choice -ge 1 -and [int]$choice -le $subnets.Count)

    return $subnets[$choice - 1]
}