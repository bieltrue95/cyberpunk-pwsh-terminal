# Uninstall Guide

Language: English | [Português](../UNINSTALL_GUIDE.md)

Learn how to completely remove Cyberpunk PowerShell Terminal from your machine.

---

## ⚠️ Before You Start

Uninstalling removes:
- ✅ PowerShell profile
- ✅ oh-my-posh theme
- ✅ Icon and color rules
- ✅ Command history (optional)
- ❌ **Does NOT** remove oh-my-posh or PowerShell 7 (must be uninstalled manually if desired)
- ❌ **Does NOT** remove Windows Terminal settings (must be adjusted manually)

---

## 🚀 Quick Uninstall

### Step 1: Open PowerShell

Click the Start menu and search for **PowerShell** (white).

### Step 2: Navigate to the Project

```powershell
cd path\to\cyberpunk-pwsh-terminal
```

### Step 3: Run Uninstall

```powershell
.\uninstall.ps1
```

**Done!** The script removes the Cyberpunk profile and creates a backup automatically.

---

## 📋 Uninstall with Complete Checklist

For a detailed verification of everything being removed, use:

```powershell
.\uninstall.ps1 -WithChecklist
```

This shows a visual checklist:

```
╔═══════════════════════════════════════════════════╗
║   Cyberpunk Terminal - Uninstall Checklist       ║
╚═══════════════════════════════════════════════════╝

==> Starting uninstall...

ℹ️  Checking profile...
✅ Profile found: C:\Users\...\profile.ps1
✅ Valid Cyberpunk profile

ℹ️  Checking theme...
✅ Theme found: C:\Users\...\themes\cyberpunk-clean.omp.json

... (more items)

Items to be removed:
  • Profile: C:\Users\...\profile.ps1
  • Theme: C:\Users\...\themes\cyberpunk-clean.omp.json
  • Data: C:\Users\...\data

Proceed with uninstall? (y/N)
```

After confirming (`y`), the script:
1. Backs up everything to a safe folder
2. Removes the items
3. Shows a final checklist confirming what was removed
4. Keeps the backup for emergency restoration

---

## 🔧 Advanced Options

### Remove Theme and Data

By default, only the profile is removed. To remove everything:

```powershell
.\uninstall.ps1 -RemoveTheme -RemoveData
```

### Force Uninstall

If the script can't confirm it's a Cyberpunk profile:

```powershell
.\uninstall.ps1 -Force
```

⚠️ **Use only if you're sure!** This removes the file without validating.

### Uninstall from Custom Profile Path

If your profile is in a custom location:

```powershell
.\uninstall.ps1 -TargetProfilePath "C:\custom\path\profile.ps1"
```

---

## 💾 Backups

Uninstall **ALWAYS** creates a backup before removing:

### Backup Location

When you run uninstall, backups go to:

```
C:\Users\<YourName>\Documents\PowerShell\cyberpunk-backup-YYYYMMDD-HHMMSS\
```

Contains:
- `profile.ps1` — Your Cyberpunk profile
- `themes/` — Themes
- `data/` — Icon rules

### Restore from Backup

If you need to restore (for example, uninstalled by mistake):

```powershell
# 1. Find the backup folder
$backups = Get-ChildItem "C:\Users\$env:USERNAME\Documents\PowerShell" -Filter "cyberpunk-backup-*" | Sort-Object LastWriteTime -Descending | Select-Object -First 1

# 2. Restore the profile
Copy-Item -Path "$($backups.FullName)\profile.ps1" -Destination $PROFILE -Force

# 3. Reload
. $PROFILE
```

---

## 🧹 Complete Cleanup

To remove **EVERYTHING** including oh-my-posh and PowerShell 7:

### Step 1: Uninstall Cyberpunk

```powershell
.\uninstall.ps1 -WithChecklist -RemoveTheme -RemoveData
```

### Step 2: Remove oh-my-posh (Optional)

```powershell
winget uninstall JanDeDobbeleer.OhMyPosh
```

### Step 3: Remove PowerShell 7 (Optional)

```powershell
winget uninstall Microsoft.PowerShell
```

### Step 4: Remove Windows Terminal Preview (Optional)

```powershell
winget uninstall Microsoft.WindowsTerminalPreview
```

### Step 5: Clean Temporary Files

```powershell
# Remove PowerShell history
$historyFile = Join-Path $env:APPDATA 'Microsoft\PowerShell\PSReadLine\ConsoleHost_history.txt'
if (Test-Path $historyFile) { Remove-Item $historyFile -Force }

# Remove update notification files
$tempFiles = @(
    (Join-Path $env:TEMP 'cyberpunk-last-update-check.txt'),
    (Join-Path $env:TEMP 'cyberpunk-notification-date.txt')
)
$tempFiles | Where-Object { Test-Path $_ } | Remove-Item -Force
```

---

## 🔍 Verify Uninstall Success

To confirm that uninstall was successful:

```powershell
# Check if Cyberpunk profile was removed
Test-Path $PROFILE

# Check if theme folder was removed
$profileDir = Split-Path -Parent $PROFILE
Test-Path (Join-Path $profileDir 'themes')

# Check if data was removed
Test-Path (Join-Path $profileDir 'data')

# If all return False, uninstall was successful!
```

---

## ⚡ Restore from Windows Terminal

If you used the `dev` profile in Windows Terminal Preview:

1. Open **Windows Terminal Preview**
2. Click **⚙️ Settings** (bottom left)
3. Go to **Profiles** (left sidebar)
4. Find the **dev** profile
5. Click **🗑️ Delete** (bottom button)

---

## 🆘 Uninstall Issues

### "Profile doesn't look like Cyberpunk"

If the script says the profile isn't Cyberpunk:

```powershell
# Option 1: Check the profile manually
cat $PROFILE | Select-String "Cyberpunk"

# Option 2: Force remove (CAREFUL!)
.\uninstall.ps1 -Force
```

### "Permission denied when removing"

If files can't be deleted (file in use):

```powershell
# 1. Open PowerShell WITHOUT loading profile
pwsh -NoLogo -NoProfile

# 2. Navigate to project
cd path\to\cyberpunk-pwsh-terminal

# 3. Try uninstall again
.\uninstall.ps1
```

### "Backup failed"

If backup can't be created:

```powershell
# Create directory manually
$profileDir = Split-Path -Parent $PROFILE
New-Item -ItemType Directory -Path $profileDir -Force | Out-Null

# Try again
.\uninstall.ps1
```

---

## 📚 See Also

- [Update Notifications](./UPDATE_NOTIFICATIONS.md) — Automatic update notification system
- [Backup & Restore](./BACKUP_RESTORE.md) — Complete backup guide
- [Troubleshooting](./TROUBLESHOOTING.md) — Problem solving
- [Getting Started](./GETTING_STARTED.md) — How to reinstall later
