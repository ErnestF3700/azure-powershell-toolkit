<#
.SYNOPSIS
Attaches an existing managed disk to a Virtual Machine.
#>

Connect-AzAccount | Out-Null

$vms = Get-AzVM

for ($i = 0; $i -lt $vms.Count; $i++) {

    Write-Host "$($i+1). $($vms[$i].Name)"
}

$choice = Read-Host "Select Virtual Machine"

$vm = Get-AzVM `
    -ResourceGroupName $vms[$choice - 1].ResourceGroupName `
    -Name $vms[$choice - 1].Name

$disks = Get-AzDisk

for ($i = 0; $i -lt $disks.Count; $i++) {

    Write-Host "$($i+1). $($disks[$i].Name)"
}

$choice = Read-Host "Select Managed Disk"

$disk = $disks[$choice - 1]

$lun = Read-Host "LUN Number"

$vm = Add-AzVMDataDisk `
    -VM $vm `
    -Name $disk.Name `
    -ManagedDiskId $disk.Id `
    -Lun $lun `
    -CreateOption Attach

Update-AzVM `
    -ResourceGroupName $vm.ResourceGroupName `
    -VM $vm

Write-Host ""
Write-Host "Disk attached successfully." -ForegroundColor Green