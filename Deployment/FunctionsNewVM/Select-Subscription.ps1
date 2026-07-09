function Select-Subscription {

    [CmdletBinding()]
    param()

    Write-Host ""
    Write-Host "Available Azure Subscriptions" -ForegroundColor Cyan
    Write-Host "--------------------------------"

    $subscriptions = Get-AzSubscription | Sort-Object Name

    for ($i = 0; $i -lt $subscriptions.Count; $i++) {
        Write-Host ("[{0}] {1}" -f ($i + 1), $subscriptions[$i].Name)
    }

    do {
        $choice = Read-Host "`nSelect subscription"

        $valid = [int]::TryParse($choice, [ref]$null)

    } until ($valid -and $choice -ge 1 -and $choice -le $subscriptions.Count)

    $subscription = $subscriptions[$choice - 1]

    Set-AzContext -SubscriptionId $subscription.Id | Out-Null

    Write-Host ""
    Write-Host "Using subscription: $($subscription.Name)" -ForegroundColor Green

    return $subscription
}