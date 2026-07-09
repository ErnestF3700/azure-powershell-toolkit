function Connect-Azure {

    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "Checking Azure connection..." -ForegroundColor Cyan

    try {
        $context = Get-AzContext -ErrorAction Stop
    }
    catch {
        $context = $null
    }

    if (-not $context) {

        Write-Host "Not connected. Opening Azure login..." -ForegroundColor Yellow

        Connect-AzAccount -ErrorAction Stop | Out-Null

        $context = Get-AzContext
    }

    Write-Host ""
    Write-Host "Connected successfully." -ForegroundColor Green
    Write-Host "Account      : $($context.Account.Id)"
    Write-Host "Tenant       : $($context.Tenant.Id)"
    Write-Host "Subscription : $($context.Subscription.Name)"
    Write-Host ""
}