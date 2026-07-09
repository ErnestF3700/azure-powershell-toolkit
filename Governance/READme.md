# Governance

This directory contains PowerShell scripts focused on Azure governance, resource auditing, and cost optimization.

The scripts help identify unused, orphaned, or underutilized Azure resources that may increase operational costs or violate governance best practices.

All scripts use the **Az PowerShell** module and can scan either a single subscription or all subscriptions accessible to the authenticated user.

---

# Prerequisites

- PowerShell 7.x (recommended)
- Az PowerShell Module

Install the module:

```powershell
Install-Module Az -Scope CurrentUser
```

Authenticate to Azure:

```powershell
Connect-AzAccount
```

For multi-tenant environments:

```powershell
Connect-AzAccount -Tenant <TenantId>
```

---

# Scripts

## Find-UnattachedDisks.ps1

### Description

Searches Azure subscriptions for managed disks that are not attached to any virtual machine.

Unattached managed disks continue to incur storage costs and are often left behind after VM deletion.

### Information collected

- Subscription
- Resource Group
- Disk Name
- Azure Region
- Disk Size (GB)
- Disk SKU
- Disk State
- Creation Date

### Example

```powershell
.\Find-UnattachedDisks.ps1
```

Export from a specific subscription:

```powershell
.\Find-UnattachedDisks.ps1 -SubscriptionId <subscription-id>
```

Output:

```
UnattachedDisks.csv
```

---

## Find-UnusedPublicIPs.ps1

### Description

Finds Public IP addresses that are not associated with any Azure resource.

Unused Public IP addresses may generate unnecessary costs and should be reviewed regularly.

### Information collected

- Subscription
- Resource Group
- Public IP Name
- IP Address
- Allocation Method
- SKU
- Azure Region

### Example

```powershell
.\Find-UnusedPublicIPs.ps1
```

Output:

```
UnusedPublicIPs.csv
```

---

## CostReport.ps1

### Description

Generates a basic Azure cost optimization report by identifying commonly unused resources.

The report combines several governance checks into a single CSV file.

### Current checks

- Unattached Managed Disks
- Unused Public IP Addresses
- Empty Network Security Groups
- Unassociated Route Tables

### Information collected

- Subscription
- Resource Type
- Resource Name
- Resource Group
- Recommendation

### Example

```powershell
.\CostReport.ps1
```

Output:

```
AzureCostReport.csv
```

---

# Typical Use Cases

These scripts are useful for:

- Azure Governance
- Cost Optimization (FinOps)
- Cloud Auditing
- Resource Cleanup
- Subscription Reviews
- Environment Health Checks
- Migration Assessments

---

# Output

All scripts export their results to CSV files that can be opened with:

- Microsoft Excel
- Power BI
- LibreOffice Calc
- PowerShell
- Python (Pandas)

---

# Best Practices

It is recommended to:

- Run governance reports on a regular schedule.
- Review resources before deleting them.
- Validate findings with resource owners.
- Maintain consistent resource tagging.
- Combine these reports with Azure Advisor recommendations.

---

# Disclaimer

These scripts are **read-only** and do not modify or delete Azure resources.

Any cleanup or remediation should be reviewed and approved before execution.
