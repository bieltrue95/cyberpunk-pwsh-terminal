# Developer Guide - Cyberpunk PowerShell Terminal

Language: English | [Português](../DEVELOPER_GUIDE.md)

Complete documentation for junior developers to understand and modify project code.

---

## 📚 Project Structure

```
cyberpunk-pwsh-terminal/
├── profile/
│   └── Microsoft.PowerShell_profile.ps1    ← Main file loaded when opening PowerShell
├── scripts/
│   ├── check-update.ps1                    ← Checks for updates on GitHub
│   ├── check.ps1                           ← Validates installation
│   ├── uninstall-checklist.ps1             ← Uninstall checklist
│   ├── test-profile.ps1                    ← Tests if profile works
│   ├── performance-analysis.ps1            ← Measures speed
│   └── ...other scripts
├── install.ps1                              ← Installation script
├── uninstall.ps1                            ← Uninstallation script
├── update.ps1                               ← Update script
├── data/
│   └── cyber-item-rules.psd1               ← Icon and color rules
├── themes/
│   └── cyberpunk-clean.omp.json            ← oh-my-posh theme
├── docs/
│   ├── DEVELOPER_GUIDE.md                  ← This file
│   ├── GETTING_STARTED.md                  ← How to install
│   ├── UPDATE_NOTIFICATIONS.md             ← Update system
│   └── ...other docs
└── terminal/
    └── windows-terminal-snippet.json       ← Windows Terminal config
```

---

## 🔧 Main File: `profile/Microsoft.PowerShell_profile.ps1`

This is the **heart of the project**. It executes automatically when you open PowerShell.

### **Section 1: History Configuration (Lines 1-78)**

**What it does:**
- Configures PSReadLine (module that controls history and autocomplete)
- Defines keyboard shortcuts (Up/Down to search, Ctrl+R to reverse search)
- Defines neon colors for syntax highlighting

**How to modify:**

#### Example 1: Increase history limit from 20000 to 50000 commands
```powershell
# BEFORE (line 45):
Set-PSReadLineOption -MaximumHistoryCount 20000

# AFTER:
Set-PSReadLineOption -MaximumHistoryCount 50000
```

#### Example 2: Change command color from blue (#E6ECFF) to green (#00FF00)
```powershell
# BEFORE (line 70):
Command          = '#E6ECFF'

# AFTER:
Command          = '#00FF00'
```

#### Example 3: Add new shortcut (Ctrl+L to clear screen)
```powershell
# Add after line 55:
Set-PSReadLineKeyHandler -Chord Ctrl+l -Function ClearScreen
```

---

### **Section 2: `hist` Command (Lines 80-104)**

**What it does:**
- Creates `hist` command to view command history
- Allows searching commands by text

**Usage examples:**
```powershell
hist                    # Last 50 commands
hist -Last 20           # Last 20 commands
hist -Search "git"      # Commands containing "git"
```

**How to modify:**

#### Example: Change default limit from 50 to 100 commands
```powershell
# BEFORE (line 85):
[int]$Last = 50

# AFTER:
[int]$Last = 100
```

---

### **Section 3: `hfind` Function (Lines 106-111)**

**What it does:**
- Quick shortcut to search history
- Just a wrapper for `hist -Search`

**Usage examples:**
```powershell
hfind docker            # Search "docker" in history
hfind npm               # Search "npm" in history
```

**How to modify:**

#### Example: Create new `gitfind` command for git
```powershell
# Add after hfind function:
function global:gitfind {
    param([Parameter(Mandatory)][string]$Text)
    hist -Search "git $Text" -Last 200
}

# Now you can use:
gitfind commit          # Search "git commit" in history
```

---

### **Section 4: Color Conversion (Lines 113-123)**

**What it does:**
- Converts hexadecimal colors (#RRGGBB) to ANSI code that terminal understands
- Allows 24-bit (16 million colors) in terminal

**How to modify:**

#### Example: Create custom color pattern
```powershell
# Add custom color variable:
$CyberMagenta = ConvertTo-CyberAnsi '#FF00FF'

# Use in:
Write-Host "Magenta text" -ForegroundColor $CyberMagenta
```

---

### **Section 5: Loading Rules (Lines 125-173)**

**What it does:**
- Loads `data/cyber-item-rules.psd1` file that defines:
  - Icons for each file type (.ps1, .json, etc)
  - Colors for folders and files

**How to modify:**

#### Example: Add new icon for .go files (Go language)
1. Open `data/cyber-item-rules.psd1`
2. Find `ExtensionIcons = @{ ... }` section
3. Add:
```powershell
'.go' = ''  # Go icon (copy from Nerd Font source)
```

---

### **Section 6: Custom `ls` Command (Lines 278-360)**

**What it does:**
- Replaces default `ls` command with icon and color version
- Shows folders with special icons, files with different colors
- Supports `-a` flag to show hidden files

**Usage examples:**
```powershell
ls                      # Normal list with icons
ls -a                   # Include hidden files
ll                      # Alias for ls with -Force flag (hidden files)
```

**How to modify:**

#### Example: Add file size column
Find `Show-CyberChildItem` function (line ~280) and add:
```powershell
# Find where it prints file name (line ~330):
Write-Host $item.Name -ForegroundColor $itemColor

# Add before:
Write-Host ("{0,10}" -f $item.Length) -ForegroundColor Gray -NoNewline
```

---

### **Section 7: oh-my-posh (Lines 368-384)**

**What it does:**
- Initializes custom prompt with oh-my-posh
- Renders Git info, language versions, etc

**How to modify:**

#### Example: Use different theme
```powershell
# BEFORE (line 380):
oh-my-posh init pwsh --config $themePath | Invoke-Expression

# AFTER (use default theme "blue"):
oh-my-posh init pwsh | Invoke-Expression

# OR use specific theme:
oh-my-posh init pwsh --config "C:\path\to\another\theme.json" | Invoke-Expression
```

---

### **Section 8: Update Check (Lines 387-498)**

**What it does:**
- Checks if new version exists on GitHub
- Shows Toast notification (Windows 10+) or console alert
- Runs in background to not block terminal

**Usage examples:**
```powershell
update-check            # Check if update available
update-check -Force     # Force check (ignore cache)
```

**How to modify:**

#### Example 1: Change cache frequency from 6h to 24h
Open `scripts/check-update.ps1` and find:
```powershell
# BEFORE (line ~52):
if ($cacheAge.TotalMinutes -lt 360) {  # 360 = 6 hours

# AFTER:
if ($cacheAge.TotalMinutes -lt 1440) {  # 1440 = 24 hours
```

#### Example 2: Add sound when update available
Add in `Check-CyberUpdate` function (line ~414):
```powershell
# After detecting update:
[console]::beep(1000, 500)  # 1000Hz tone for 500ms
```

---

## 🔍 Script: `scripts/check-update.ps1`

**What it does:**
- Checks GitHub API for new version
- Implements cache (6h) to not overload API
- Returns current vs new version info

### **Main sections:**

#### Section 1: Initial Validation (Lines 1-45)
```powershell
# Check if VERSION file exists
if (-not (Test-Path -LiteralPath $versionFile)) {
    Write-Error-Custom "VERSION file not found"
    return @{ UpdateAvailable = $false; Error = $true }
}
```

**How to modify:** Add different connection validation
```powershell
# Change from:
$null = Invoke-WebRequest -Uri "https://api.github.com" -TimeoutSec 5

# To:
$null = Invoke-WebRequest -Uri "https://raw.githubusercontent.com" -TimeoutSec 5
```

#### Section 2: Cache Check (Lines 47-90)
```powershell
# If cache file exists and less than 6 hours old:
if ($cacheAge.TotalMinutes -lt 360) {
    return @{ ... }  # Return cached result
}
```

**How to modify:** Debug if cache is being used
```powershell
# Add after line 60:
Write-Host "Cache valid! Skipping API call..." -ForegroundColor Green
```

---

## 📝 Script: `install.ps1`

**What it does:**
- Copies profile, theme, and rules to user's PowerShell folder
- Automatic backup of old profile
- Configures Windows Terminal (optional)

### **Main flow:**

```
1. Check prerequisites (PowerShell 7, oh-my-posh, fonts)
   ↓
2. Create destination folder
   ↓
3. Backup old profile
   ↓
4. Copy files:
   - profile
   - theme
   - data/rules
   ↓
5. (Optional) Configure Windows Terminal
```

**How to modify:**

#### Example: Add PowerShell module installation
```powershell
# Add at end of script (before "Install complete"):
Write-Step "Installing PowerShell modules"
Install-Module PSReadLine -Force
```

---

## 🗑️ Script: `uninstall.ps1`

**What it does:**
- Removes PowerShell profile
- Removes theme and data (optional)
- Backup before removing

### **Flow:**

```
1. Validate it's a Cyberpunk profile
   ↓
2. Full backup
   ↓
3. Remove files:
   - Profile
   - Theme (if -RemoveTheme)
   - Data (if -RemoveData)
```

**How to modify:**

#### Example: Add cache file removal
```powershell
# Add after line 51 (remove data):
$cacheFile = Join-Path $env:TEMP 'cyberpunk-cache.json'
if (Test-Path -LiteralPath $cacheFile) {
    Remove-Item -LiteralPath $cacheFile -Force
}
```

---

## 🧪 Script: `scripts/check.ps1`

**What it does:**
- Validates everything is installed correctly
- Checks PowerShell script syntax
- Validates JSON files

### **Checklist:**
- PowerShell 7+? ✓
- oh-my-posh installed? ✓
- Nerd Font? ✓
- Script syntax? ✓
- Valid JSON? ✓

**How to modify:**

#### Example: Add Git check
```powershell
# Add after PowerShell check:
Write-Step "Checking Git"
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Fail "Git not found in PATH"
    $failures++
} else {
    Write-Pass "Git found"
}
```

---

## 🎨 File: `data/cyber-item-rules.psd1`

**What it does:**
- Defines icons for file extensions (.ps1, .json, etc)
- Defines colors for file types and directories

### **Structure:**

```powershell
@{
    # Default icon, default color
    Defaults = @{
        FileIcon = ''
        DirectoryIcon = ''
        FileColor = '#E6ECFF'
        DirectoryColor = '#00E5FF'
    }

    # Rules by pattern (for specific names)
    DirectoryColorRules = @(
        @{ Pattern = '^node_modules$'; Color = '#FF6B6B' }
    )

    # Icons by extension
    ExtensionIcons = @{
        '.ps1' = '󰨊'
        '.json' = ''
        '.git' = ''
    }
}
```

**How to modify:**

#### Example: Change node_modules color to red
```powershell
# BEFORE:
@{ Pattern = '^node_modules$'; Color = '#FF6B6B' }

# AFTER:
@{ Pattern = '^node_modules$'; Color = '#FF0000' }
```

#### Example: Add icon for .go files
```powershell
# Add in ExtensionIcons:
'.go' = ''  # Go icon
```

---

## 🚀 Complete Usage Flow

### **1. Installation**
```powershell
pwsh -NoLogo -NoProfile -File .\setup.ps1
# Or manual:
.\install.ps1
```

### **2. Terminal Opening**
```
PowerShell starts
   ↓
Loads Microsoft.PowerShell_profile.ps1
   ↓
PSReadLine configures history
   ↓
oh-my-posh renders prompt
   ↓
Check-CyberUpdate checks for updates (in background)
   ↓
Terminal ready to use
```

### **3. Usage**
```powershell
ls                   # See files with icons
hist -Search git     # Search history
update-check         # Check for updates
```

### **4. Update**
```powershell
.\update.ps1         # Do pull, reinstall
```

### **5. Uninstall**
```powershell
.\uninstall.ps1 -WithChecklist   # Remove everything with checklist
```

---

## 📊 Flow Diagram

```
┌─────────────────────────────────┐
│  User opens PowerShell          │
└────────────┬────────────────────┘
             │
             ↓
┌─────────────────────────────────┐
│ $PROFILE loads:                 │
│ Microsoft.PowerShell_profile.ps1│
└────────────┬────────────────────┘
             │
             ├─→ PSReadLine config
             ├─→ Aliases (ls, dir)
             ├─→ Functions (hist, hfind)
             ├─→ oh-my-posh init
             └─→ Check-CyberUpdate (async)
                        │
                        ↓
             ┌──────────────────────┐
             │ Check cache 6h       │
             └──────┬───────────────┘
                    │
          ┌─────────┴─────────┐
          │                   │
          ↓                   ↓
      Cache valid        Call GitHub
      (return)           API
          │                   │
          │                   ↓
          │            Compare version
          │                   │
          └─────────┬─────────┘
                    │
                    ↓
          ┌──────────────────────┐
          │ Update available?    │
          └──────┬───────┬──────┘
                 │       │
              YES│       │NO
                 │       │
                 ↓       ↓
            Toast    Nothing
            Notif.   happens
```

---

## 🔧 Practical Modification Examples

### **Example 1: Add new alias**

You want to add `ll` (long list) = `ls` with extra details.

**File:** `profile/Microsoft.PowerShell_profile.ps1`

**Code to add (after line 360):**
```powershell
# Alias 'll' shows detailed list with size
function global:ll-details {
    ls @args | Format-Table Name, Length, Mode, LastWriteTime
}

# Use as:
# ll-details C:\
```

### **Example 2: Change prompt color**

**File:** `profile/Microsoft.PowerShell_profile.ps1`

Find line ~380 where oh-my-posh is initialized:
```powershell
# To use "star" theme instead of cyberpunk-clean:
oh-my-posh init pwsh --config "C:\Program Files\oh-my-posh\themes\star.omp.json" | Invoke-Expression
```

### **Example 3: Add custom function**

```powershell
# Function to open file in VSCode
function code-open {
    param([string]$Path)
    code $Path
}

# Use as:
code-open C:\Users\Gabriel\Documents\project
```

---

## 📖 Additional Resources

- **PowerShell Docs:** https://docs.microsoft.com/powershell/
- **oh-my-posh:** https://ohmyposh.dev/
- **Nerd Fonts:** https://www.nerdfonts.com/
- **Windows Terminal:** https://github.com/microsoft/terminal

---

## ❓ Common Questions

**Q: How to change terminal font?**
A: Windows Terminal → Settings → Profile → Appearance → Font

**Q: How to add new icon?**
A: Edit `data/cyber-item-rules.psd1` and copy icon from nerd fonts

**Q: How to debug if something doesn't work?**
A: Run `.\scripts\check.ps1` for complete diagnostics

---

**Last updated:** 2026-06-20
**Project version:** 2.2.0
