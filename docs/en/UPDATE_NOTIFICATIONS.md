# Update Notifications

Language: English | [Português](../UPDATE_NOTIFICATIONS.md)

Cyberpunk Terminal automatically checks for new versions available and notifies you once per day.

---

## 🔔 How It Works

### Automatic Verification

When you open a new PowerShell terminal:

1. **Background verification** — The `check-update.ps1` script checks GitHub in a separate thread/job (doesn't block the prompt)
2. **One notification per day** — You only get notified once a day, even if you open multiple terminals
3. **Smart caching** — Results are cached for 6 hours (reduces unnecessary GitHub API calls)
4. **Prompt appears immediately** — Your terminal is ready to use without waiting for the network check (notification arrives a few seconds later if there's an update)

### Notification Options

If there is an update available, you will see:

#### Windows Toast Notification (Automatic)
Appears in the lower right corner of the screen as a Windows notification:
```
┌──────────────────────────────┐
│ 🔔 Cyberpunk Terminal Update  │
│ New update: v2.1 → v2.2      │
│                               │
│  [View Details]  [Dismiss]    │
└──────────────────────────────┘
```

If Toast fails (older systems), you'll see a colored box in the console:
```
╔════════════════════════════════════════════════════╗
║  🔔 UPDATE AVAILABLE                              ║
║                                                    ║
║  Current version: v2.1.0                          ║
║  New version:     v2.2.0                          ║
║                                                    ║
║  Type: update-check                               ║
║  to view details and update                        ║
║                                                    ║
╚════════════════════════════════════════════════════╝
```

---

## 📋 View Update Details

To see the full changelog and new version details, use:

```powershell
update-check
```

This shows:
- Current vs new version
- Link to full changelog on GitHub
- Command to install the update

---

## ⬆️ Install Update

To install the new version:

### Option 1: Guided Scripts (Recommended)

```powershell
.\update.ps1
```

The `update.ps1` script:
- ✅ Secure backup of your profile
- ✅ Pull new version from Git
- ✅ Integrity validation
- ✅ Safe profile reinstallation
- ✅ Automatic diagnostics

### Option 2: Manual Update

If you prefer manual control:

```powershell
git pull origin main
.\install.ps1
```

---

## 🔍 Manual Check

To check for updates without waiting for automatic notification:

```powershell
update-check -Force
```

---

## 🚫 Disable Notifications

If you don't want to be notified automatically, there are two options:

### Option 1: Silence for One Day

Dismiss the notification and it won't appear again until tomorrow.

### Option 2: Disable Completely

Edit your profile and comment the last line:

```powershell
# Comment this line to disable automatic notifications:
# Check-CyberUpdate -ErrorAction SilentlyContinue
```

You can still use `update-check` manually whenever you want.

---

## 📁 Control Files

Update verification uses these temporary files:

| File | Location | Purpose |
| --- | --- | --- |
| `cyberpunk-notification-date.txt` | `%TEMP%` | Tracks last notification date |
| `cyberpunk-last-update-check.txt` | `%TEMP%` | Stores last verification result |

These files are automatically cleaned up during uninstall.

---

## ❓ Troubleshooting

### Verification is too slow

First check can take a few seconds. If it persists:

```powershell
# Check your internet connection
ping github.com

# Test GitHub API manually
Invoke-RestMethod https://api.github.com
```

### Toast notification doesn't appear

This is common on older systems. The script will automatically show the message in the console instead.
To test manually:

```powershell
# Test notification
$today = Get-Date -Format 'yyyy-MM-dd'
$notificationFile = Join-Path $env:TEMP 'cyberpunk-notification-date.txt'
Remove-Item -Path $notificationFile -ErrorAction SilentlyContinue

# Open a new terminal to see notification
```

### Verification fails with permission error

Ensure that `%TEMP%` (Windows temporary folder) has write permissions:

```powershell
# Test if you can write to %TEMP%
$testFile = Join-Path $env:TEMP 'test-write.txt'
'test' | Set-Content -Path $testFile -Force
Remove-Item -Path $testFile -Force
```

---

## 📚 See Also

- [Update Scripts](./UPDATE_SCRIPTS.md) — Detailed update scripts
- [Uninstall Guide](./UNINSTALL_GUIDE.md) — How to completely uninstall
- [Backup & Restore](./BACKUP_RESTORE.md) — Profile backup and restore
