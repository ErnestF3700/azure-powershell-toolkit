function Select-VMSize {

    [CmdletBinding()]
    param()

    $sizes = @(
        "Standard_B2s"
        "Standard_B2ms"
        "Standard_D2s_v5"
        "Standard_D4s_v5"
        "Standard_D8s_v5"
        "Standard_E2s_v5"
    )

    Write-Host ""
    Write-Host "Available VM Sizes" -ForegroundColor Cyan
    Write-Host "-------------------------------"

    for ($i = 0; $i -lt $sizes.Count; $i++) {
        Write-Host ("[{0}] {1}" -f ($i + 1), $sizes[$i])
    }

    do {
        $choice = Read-Host "`nSelect VM Size"
    } until (
        [int]::TryParse($choice, [ref]$null) -and
        $choice -ge 1 -and
        $choice -le $sizes.Count
    )

    return $sizes[$choice - 1]
}