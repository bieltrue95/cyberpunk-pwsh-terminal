# Cyberpunk PowerShell Terminal - Visual Diagrams

Language: English | [Português](../DIAGRAMS.md)

Interactive diagrams created with Excalidraw to visualize the project architecture and flows.

---

## 📊 Available Diagrams

### 1. **Complete Project Flow**

Shows the three main phases: Installation → Runtime → Uninstallation

- **Blue Zone (Installation)**: install.ps1 and setup
- **Purple Zone (Runtime)**: Profile and execution
- **Red Zone (Uninstallation)**: uninstall scripts

🔗 **[Open Interactive Diagram →](https://excalidraw.com/#json=QIoddZeBEYkrpv0Cr--P7,ihTTvWFUKlCQf3SErG2xhQ)**

**How to use:**
- Click to select elements
- Drag to move
- Use mouse wheel to zoom
- Click "Edit in Excalidraw" to edit

---

### 2. **Detailed Update Check Flow**

Shows the asynchronous execution flow of update checking

- **Phase 1**: Quick check (already notified today?)
- **Phase 2**: ThreadJob in background
- **Phase 3**: Non-blocking result

🔗 **[Open Interactive Diagram →](https://excalidraw.com/#json=QBEMyS-3zMRg-JmvwfaTV,cYmhmWc5cvpXy63H8jOmJw)**

**Highlight:**
- Profile returns control BEFORE job finishes
- Notification appears asynchronously
- No prompt blocking

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
