# Compute

This directory contains PowerShell scripts for Azure Virtual Machine inventory, performance analysis, and storage auditing.

The scripts use the **Az PowerShell** module and are intended for Azure administrators, DevOps engineers, and cloud engineers who need to collect information from one or multiple Azure subscriptions.

## Prerequisites

- PowerShell 7.x (recommended)
- Az PowerShell Module
- Authenticated Azure session

```powershell
Install-Module Az -Scope CurrentUser
Connect-AzAccount
```

---

# Scripts

## VMInventory.ps1

### Description

Creates a complete inventory of Azure Virtual Machines across one or multiple Azure subscriptions.

The script collects information about every VM and exports the results to a CSV file.

### Information collected

- Subscription
- Resource Group
- Virtual Machine Name
- Azure Region
- Power State
- VM Size
- Operating System
- Private IP Address
- Public IP Address
- OS Disk
- Data Disks
- Availability Zone
- Tags

### Example

```powershell
.\VMInventory.ps1
```

Export inventory from a specific subscription.

```powershell
.\VMInventory.ps1 -SubscriptionId <subscription-id>
```

Output:

```
VMInventory.csv
```

---

## VMPerformance.ps1

### Description

Collects Azure Monitor performance metrics for Azure Virtual Machines.

The script calculates average CPU utilization over a configurable time period and exports the results to CSV.

This report can be used for:

- VM rightsizing
- Capacity planning
- Performance analysis
- Resource optimization

### Metrics

Currently collected:

- Average CPU Percentage

The script can easily be extended to include:

- Available Memory
- Network In/Out
- Disk Read/Write Operations
- Disk Throughput
- IOPS

### Example

Collect metrics for the last 30 days.

```powershell
.\VMPerformance.ps1
```

Collect metrics for the last 7 days.

```powershell
.\VMPerformance.ps1 -Days 7
```

Output:

```
VMPerformance.csv
```

---

## UltraDiskReport.ps1

### Description

Searches all Azure subscriptions for Ultra SSD managed disks and generates an inventory report.

Useful for:

- Cost optimization
- Storage auditing
- Capacity planning
- Azure governance

### Information collected

- Subscription
- Disk Name
- Resource Group
- Region
- Disk Size (GB)
- Provisioned IOPS
- Provisioned Throughput (MB/s)
- Managed By (VM)
- Disk State

### Example

```powershell
.\UltraDiskReport.ps1
```

Output:

```
UltraDiskReport.csv
```

---

# Authentication

Login before running any script.

```powershell
Connect-AzAccount
```

If working with multiple tenants:

```powershell
Connect-AzAccount -Tenant <TenantId>
```

---

# Output

Each script exports results to a CSV file that can be opened in:

- Microsoft Excel
- Power BI
- LibreOffice Calc
- PowerShell
- Python (Pandas)
