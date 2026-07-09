Connect-AzAccount | Out-Null

$nsgs = Get-AzNetworkSecurityGroup

for ($i = 0; $i -lt $nsgs.Count; $i++) {

    Write-Host "$($i+1). $($nsgs[$i].Name)"
}

$choice = Read-Host "Select NSG"

$nsg = $nsgs[$choice - 1]

Write-Host ""
Write-Host "1. Allow RDP"
Write-Host "2. Allow SSH"
Write-Host "3. Allow HTTPS"

$rule = Read-Host "Select Rule"

switch ($rule) {

    1 {
        $name = "Allow-RDP"
        $port = 3389
    }

    2 {
        $name = "Allow-SSH"
        $port = 22
    }

    3 {
        $name = "Allow-HTTPS"
        $port = 443
    }

    default {
        throw "Invalid selection."
    }

}

$nsg | Add-AzNetworkSecurityRuleConfig `
    -Name $name `
    -Description $name `
    -Access Allow `
    -Protocol Tcp `
    -Direction Inbound `
    -Priority 100 `
    -SourceAddressPrefix * `
    -SourcePortRange * `
    -DestinationAddressPrefix * `
    -DestinationPortRange $port | Set-AzNetworkSecurityGroup

Write-Host "Rule added." -ForegroundColor Green