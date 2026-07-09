# Networking

This directory contains PowerShell scripts for auditing and documenting Azure networking resources.

The scripts use the **Az PowerShell** module to collect networking configuration across one or multiple Azure subscriptions and export the results to CSV files.

These reports are useful for:

- Network documentation
- Security reviews
- Infrastructure auditing
- Migration planning
- Azure governance
- Troubleshooting

---

# Prerequisites

- PowerShell 7.x (recommended)
- Az PowerShell Module

Install the required module:

```powershell
Install-Module Az -Scope CurrentUser
```

Authenticate to Azure:

```powershell
Connect-AzAccount
```

---

# Scripts

## Export-VNetPeerings.ps1

### Description

Exports Azure Virtual Network Peering configuration from one or multiple Azure subscriptions.

The report provides visibility into network connectivity between Azure Virtual Networks.

### Information collected

- Subscription
- Resource Group
- Virtual Network
- Azure Region
- Peering Name
- Remote Virtual Network
- Peering State
- Allow Forwarded Traffic
- Allow Gateway Transit
- Use Remote Gateways

### Example

Export peerings from all subscriptions.

```powershell
.\Export-VNetPeerings.ps1
```

Export from a specific subscription.

```powershell
.\Export-VNetPeerings.ps1 -SubscriptionId <subscription-id>
```

Output:

```
VNetPeerings.csv
```

---

## Export-NSGRules.ps1

### Description

Exports all Azure Network Security Group (NSG) rules.

The report can be used to review firewall configuration and identify overly permissive rules.

### Information collected

- Subscription
- Resource Group
- Network Security Group
- Rule Name
- Priority
- Direction
- Access
- Protocol
- Source Address
- Source Port
- Destination Address
- Destination Port

### Example

```powershell
.\Export-NSGRules.ps1
```

Output:

```
NSGRules.csv
```

Typical use cases:

- Firewall auditing
- Security reviews
- Compliance documentation
- Rule validation

---

## Export-RouteTables.ps1

### Description

Exports Azure Route Tables and all configured routes.

The report helps administrators understand traffic routing within Azure virtual networks.

### Information collected

- Subscription
- Resource Group
- Route Table
- Route Name
- Address Prefix
- Next Hop Type
- Next Hop IP Address

### Example

```powershell
.\Export-RouteTables.ps1
```

Output:

```
RouteTables.csv
```

Typical use cases:

- Network troubleshooting
- Migration planning
- Route validation
- Infrastructure documentation

---

# Authentication

Authenticate before running any script.

```powershell
Connect-AzAccount
```

For multi-tenant environments:

```powershell
Connect-AzAccount -Tenant <TenantId>
```

---

# Output

Each script exports the collected data to CSV files that can be opened with:

- Microsoft Excel
- Power BI
- LibreOffice Calc
- PowerShell
- Python (Pandas)

---

# Use Cases

These scripts can be used to:

- Document Azure networking resources
- Audit Virtual Network connectivity
- Review Network Security Group rules
- Validate User Defined Routes (UDRs)
- Support security assessments
- Prepare migration inventories
- Generate reports for governance and compliance

---
