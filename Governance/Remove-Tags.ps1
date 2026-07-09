<#
.SYNOPSIS
Removes a tag from an Azure Resource.
#>

Connect-AzAccount | Out-Null

$resources = Get-AzResource

for ($i = 0; $i -lt $resources.Count; $i++) {

    Write-Host "$($i+1). $($resources[$i].Name)"
}

$choice = Read-Host "Select Resource"

$resource = $resources[$choice - 1]

if (-not $resource.Tags) {

    Write-Host "Resource has no tags." -ForegroundColor Yellow
    return
}

Write-Host ""
Write-Host "Current Tags"

$resource.Tags.Keys | ForEach-Object {

    Write-Host "- $_"
}

$key = Read-Host "Tag to remove"

$tags = @{} + $resource.Tags

$tags.Remove($key)

Set-AzResource `
    -ResourceId $resource.ResourceId `
    -Tag $tags `
    -Force

Write-Host ""
Write-Host "Tag removed." -ForegroundColor Green