function New-AzureDataDisks {

    [CmdletBinding()]
    param(
        [Parameter(Mandatory)]
        [string]$ResourceGroup,

        [Parameter(Mandatory)]
        [string]$Location
    )

    $disks = @()

    $count = Read-Host "How many data disks? (0-4)"

    if ([int]$count -eq 0) {
        return $disks
    }

    for ($i = 1; $i -le $count; $i++) {

        $size = Read-Host "Disk $i size (GB)"

        $config = New-AzDiskConfig `
            -Location $Location `
            -SkuName StandardSSD_LRS `
            -CreateOption Empty `
            -DiskSizeGB $size

        $disk = New-AzDisk `
            -ResourceGroupName $ResourceGroup `
            -DiskName "DataDisk$i" `
            -Disk $config

        $disks += $disk
    }

    return $disks
}