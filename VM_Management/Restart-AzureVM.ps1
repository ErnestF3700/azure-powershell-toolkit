<#
.SYNOPSIS
Restarts an Azure Virtual Machine.
#>

Connect-AzAccount | Out-Null

$vm = Get-AzVM

for ($i = 0; $i -lt $vm.Count; $i++) {
    Write-Host "$($i+1). $($vm[$i].Name)"
}

$choice = Read-Host "Select VM"

$selected = $vm[$choice - 1]

Restart-AzVM `
    -ResourceGroupName $selected.ResourceGroupName `
    -Name $selected.Name

Write-Host "VM restarted." -ForegroundColor Green