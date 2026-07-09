function Select-Image {

    [CmdletBinding()]
    param()

    $images = @(
        "Windows Server 2025"
        "Windows Server 2022"
        "Ubuntu Server 24.04 LTS"
        "Ubuntu Server 22.04 LTS"
        "Debian 12"
        "Red Hat Enterprise Linux 9"
    )

    Write-Host ""
    Write-Host "Available Operating Systems" -ForegroundColor Cyan
    Write-Host "--------------------------------"

    for ($i = 0; $i -lt $images.Count; $i++) {

        Write-Host ("[{0}] {1}" -f ($i + 1), $images[$i])
    }

    do {

        $choice = Read-Host "`nSelect Operating System"

    } until ([int]$choice -ge 1 -and [int]$choice -le $images.Count)

    switch ($choice) {

        1 { return "Windows2025" }

        2 { return "Windows2022" }

        3 { return "Ubuntu2404" }

        4 { return "Ubuntu2204" }

        5 { return "Debian12" }

        6 { return "RHEL9" }

    }
}