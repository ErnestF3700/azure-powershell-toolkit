function Select-ResourceGroup {

    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "Available Resource Groups" -ForegroundColor Cyan
    Write-Host "--------------------------------"

    $resourceGroups = Get-AzResourceGroup | Sort-Object ResourceGroupName

    for ($i = 0; $i -lt $resourceGroups.Count; $i++) {

        Write-Host ("[{0}] {1}" -f ($i + 1), $resourceGroups[$i].ResourceGroupName)
    }

    Write-Host ("[{0}] Create new Resource Group" -f ($resourceGroups.Count + 1))

    do {

        $choice = Read-Host "`nSelect Resource Group"

    } until ([int]$choice -ge 1 -and [int]$choice -le ($resourceGroups.Count + 1))

    if ($choice -eq ($resourceGroups.Count + 1)) {

        $name = Read-Host "Resource Group Name"

        $location = Read-Host "Azure Region (e.g. westeurope)"

        $rg = New-AzResourceGroup `
            -Name $name `
            -Location $location

        Write-Host ""
        Write-Host "Resource Group created." -ForegroundColor Green

        return $rg
    }

    return $resourceGroups[$choice - 1]
}