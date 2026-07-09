<#
.SYNOPSIS
Converts standalone Terraform (.tf) files into module folder structures.

.DESCRIPTION
Creates a directory for each .tf file, moves the original file to main.tf,
and generates the standard Terraform module files:
- variables.tf
- outputs.tf
- versions.tf
- locals.tf
- README.md
#>

Get-ChildItem -File | ForEach-Object {
    $name = $_.Name
    $tmp = "$name.tmp"

    Rename-Item $_.FullName $tmp

    New-Item -ItemType Directory -Path $name | Out-Null

    Move-Item $tmp "$name\main.tf"

    "variables.tf", "outputs.tf", "versions.tf", "locals.tf", "README.md" |
    ForEach-Object {
        New-Item -ItemType File -Path "$name\$_" | Out-Null
    }
}