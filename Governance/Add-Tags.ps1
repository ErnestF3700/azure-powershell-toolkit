<#
.SYNOPSIS
Adds or updates Azure Resource tags.
#>

Connect-AzAccount | Out-Null

$resources = Get-AzResource

for ($i = 0; $i -lt $resources.Count; $i++) {
    Write-Host "$($i+1). $($resources[$i].Name) [$($resources[$i].ResourceType)]"
}

$choice = Read-Host "Select Resource"

$resource = $resources[$choice - 1]

$key = Read-Host "Tag Name"

$value = Read-Host "Tag Value"

$tags = @{}

if ($resource.Tags) {
    $tags = @{} + $resource.Tags
}

$tags[$key] = $value

Set-AzResource `
    -ResourceId $resource.ResourceId `
    -Tag $tags `
    -Force

Write-Host ""
Write-Host "Tag added successfully." -ForegroundColor Green