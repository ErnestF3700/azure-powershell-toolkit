<#
.SYNOPSIS
Removes an Azure Virtual Machine.
#>

Connect-AzAccount | Out-Null

$vm = Get-AzVM

for ($i = 0; $i -lt $vm.Count; $i++) {
    Write-Host "$($i+1). $($vm[$i].Name)"
}

$choice = Read-Host "Select VM"

$selected = $vm[$choice - 1]

$confirm = Read-Host "Delete $($selected.Name)? (YES/NO)"

if ($confirm -ne "YES") {

    Write-Host "Operation cancelled." -ForegroundColor Yellow
    return
}

Remove-AzVM `
    -ResourceGroupName $selected.ResourceGroupName `
    -Name $selected.Name `
    -Force

Write-Host "VM deleted." -ForegroundColor Green