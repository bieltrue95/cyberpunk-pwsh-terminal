# Cyberpunk PowerShell Terminal - Visual Diagrams

Language: English | [Português](../DIAGRAMS.md)

Interactive diagrams created with Excalidraw to visualize the project architecture and flows.

---

## 📊 Available Diagrams

### 1. **Complete Project Flow**

Shows the three main phases: Installation → Runtime → Uninstallation

```
┌─────────────────────────────────────────────────────────────┐
│         CYBERPUNK TERMINAL - COMPLETE SYSTEM FLOW           │
│                                                             │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐     │
│  │ 1.INSTALL│        │2.RUNTIME │        │3.UNINSTAL│     │
│  │ install  │        │ Profile  │        │ uninstall│     │
│  │ .ps1     │        │ load     │        │ .ps1     │     │
│  └─────┬────┘        └────┬─────┘        └────┬─────┘     │
│        │                  │                    │            │
│        ↓                  ↓                    ↓            │
│  ┌──────────┐        ┌──────────┐        ┌──────────┐     │
│  │Copy Files│        │ Commands │        │ Restore  │     │
│  │ Theme    │        │ Ready    │        │ Backup   │     │
│  │ Rules    │        │ls,hist.. │        │ Clean    │     │
│  └──────────┘        └──────────┘        └──────────┘     │
│        │                  │                    │            │
│        ↓                  ↓                    ↓            │
│  ✓ Profile         ✓ Terminal          ✓ Removal       │
│    Installed         Ready              Complete       │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**Zones:**
- 🔵 **Blue (Installation)**: install.ps1, copy files, backup
- 🟣 **Purple (Runtime)**: Profile load, commands, update check
- 🔴 **Red (Uninstallation)**: uninstall, cleanup, restore

---

### 2. **Detailed Update Check Flow**

Shows the **asynchronous** execution flow of update checking

```
┌─────────────────────────────────────────────────────────┐
│          UPDATE CHECK - ASYNCHRONOUS EXECUTION          │
│                                                         │
│  Check-CyberUpdate called                              │
│         │                                              │
│         ↓                                              │
│  ┌─────────────────────────┐                          │
│  │ Already notified today? │                          │
│  │ (fast sync check)       │                          │
│  └────────┬───────────┬────┘                          │
│       YES │           │ NO                             │
│           │           │                                │
│    ┌──────↓──┐   ┌────↓──────────┐                    │
│    │ Return  │   │ Start Job     │                    │
│    │ (skip)  │   │ check-update  │                    │
│    └─────────┘   └────┬──────────┘                    │
│                        │                               │
│                        ↓                               │
│         ┌──────────────────────────┐                  │
│         │ Profile Finishes         │                  │
│         │ PROMPT READY             │                  │
│         │ (User can type now)      │                  │
│         └──────────────────────────┘                  │
│                        │                               │
│        Meanwhile:      │      ↓                        │
│        Job running     │  Toast notification           │
│        in background   │  (if update found)            │
│                        │  No wait!                     │
│                        ↓                               │
│                   ┌─────────────┐                     │
│                   │ Notification│                     │
│                   │ Async fired │                     │
│                   └─────────────┘                     │
│                                                       │
└─────────────────────────────────────────────────────┘
```

**Highlights:**
- ✅ Profile returns control BEFORE job finishes
- ✅ Check runs in background (ThreadJob)
- ✅ Notification fires asynchronously when update found
- ✅ No prompt blocking

---

## 🎨 Color Pattern

| Color | Meaning | Usage |
|-------|---------|-------|
| 🔵 Blue | Input/Installation | install.ps1, setup scripts |
| 🟣 Purple | Processing/Runtime | Profile, ThreadJob, processing |
| 🟢 Green | Success/Output | Commands ready, valid cache |
| 🟠 Orange | Warning/Pending | Verification, cache check |
| 🔴 Red | Error/Removal | uninstall, cleanup |
| 🔶 Yellow | Note/Decision | Backup, verification |

---

## 📖 Related Documentation

| Document | Description |
|----------|-------------|
| [ARCHITECTURE_FLOW.md](ARCHITECTURE_FLOW.md) | ASCII diagrams + detailed explanations |
| [DEVELOPER_GUIDE.md](DEVELOPER_GUIDE.md) | Code commented line by line |
| [UPDATE_NOTIFICATIONS.md](UPDATE_NOTIFICATIONS.md) | Notification system |
| [GETTING_STARTED.md](GETTING_STARTED.md) | Installation and setup |

---

## 💡 How to Contribute

Want to update the diagrams?

1. Click on the diagram link
2. Click "Edit in Excalidraw" (top corner)
3. Make your changes
4. Use "Save to browser" to save
5. Copy the new URL
6. Open PR with the updated URL in this file

---

## 🔄 Update History

| Date | Diagram | Change |
|------|---------|--------|
| 2026-06-20 | Complete Flow | Created with 3 zones |
| 2026-06-20 | Update Check Flow | Created with async flow |

---

## 📌 Notes

- Diagrams are hosted on Excalidraw.com
- Shareable links with read/edit access
- Compatible with modern browsers
- No login required to view

---

**Last updated:** 2026-06-20  
**Project version:** 2.2.0
