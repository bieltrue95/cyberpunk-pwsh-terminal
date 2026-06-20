# Cyberpunk PowerShell Terminal - Visual Diagrams

Language: English | [Português](../DIAGRAMS.md)

Visual diagrams created in ASCII to visualize the project architecture and flows.

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

## 💡 Contributing

Want to add or improve a diagram?

1. Edit the markdown file
2. Use ASCII characters to draw
3. Keep the color pattern
4. Test the visualization
5. Open a PR with the improvement

---

## 🔄 Update History

| Date | Diagram | Change |
|------|---------|--------|
| 2026-06-20 | Complete Flow | ASCII diagram created |
| 2026-06-20 | Update Check Flow | ASCII diagram created |

---

## 📌 Notes

- Diagrams are rendered as plain text (ASCII art)
- Compatible with any markdown viewer
- Always available offline in the repository
- Easy to edit and version with git

---

**Last updated:** 2026-06-20  
**Project version:** 2.2.0
