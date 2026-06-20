# Cyberpunk PowerShell Terminal - Architecture & Flow Documentation

Idioma: Português do Brasil | [English](en/ARCHITECTURE_FLOW.md)

Documentação visual e técnica do fluxo completo do projeto usando diagramas Excalidraw.

---

## 📊 Diagramas Visuais

### Fluxo Completo do Projeto

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                   CYBERPUNK POWERSHELL TERMINAL - COMPLETE FLOW             │
│                                                                             │
│  ┌─────────────────────┐  ┌──────────────────────────┐  ┌─────────────────┐│
│  │   INSTALLATION      │  │   RUNTIME / PROFILE      │  │  UNINSTALLATION ││
│  │                     │  │   EXECUTION              │  │                 ││
│  │                     │  │                          │  │                 ││
│  │  1. install.ps1     │  │  1. Open PowerShell      │  │  1. uninstall   ││
│  │        │            │  │        │                 │  │        │        ││
│  │        ↓            │  │        ↓                 │  │        ↓        ││
│  │  2. Copy Files      │  │  2. Load Profile         │  │  2. Checklist   ││
│  │     (Profile,       │  │     (Microsoft.          │  │     Script      ││
│  │      Theme, Rules)  │  │      PowerShell_         │  │        │        ││
│  │        │            │  │      profile.ps1)        │  │        ↓        ││
│  │        ↓            │  │        │                 │  │  3. Verify      ││
│  │  3. Backup Old      │  │        ├──> PSReadLine   │  │     Removal     ││
│  │     Profile         │  │        │    Setup        │  │        │        ││
│  │        │            │  │        │                 │  │        ↓        ││
│  │        ↓            │  │        ├──> oh-my-posh   │  │  4. Restore     ││
│  │  ✓ INSTALLED        │  │        │    Prompt       │  │     Backup      ││
│  │                     │  │        │                 │  │                 ││
│  │                     │  │        ↓                 │  │  ✓ UNINSTALLED   ││
│  │                     │  │  3. Commands Ready       │  │                 ││
│  │                     │  │     (ls, hist, update)   │  │                 ││
│  │                     │  │        │                 │  │                 ││
│  │                     │  │        ↓                 │  │                 ││
│  │                     │  │  4. Check Updates        │  │                 ││
│  │                     │  │     (Background/Async)   │  │                 ││
│  │                     │  │        │                 │  │                 ││
│  │                     │  │        ├──> Cache Valid? │  │                 ││
│  │                     │  │        │                 │  │                 ││
│  │                     │  │        ├──> API Call     │  │                 ││
│  │                     │  │        │                 │  │                 ││
│  │                     │  │        ↓                 │  │                 ││
│  │                     │  │  5. Toast Notification   │  │                 ││
│  │                     │  │     (if update found)    │  │                 ││
│  │                     │  │                          │  │                 ││
│  └─────────────────────┘  └──────────────────────────┘  └─────────────────┘│
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

### Fluxo Detalhado de Verificação de Atualização

```
┌─────────────────────────────────────────────────────────────────┐
│           UPDATE CHECK FLOW - ASYNCHRONOUS EXECUTION            │
│                                                                 │
│  ┌───────────────────────────────────────┐                     │
│  │ Check-CyberUpdate Called              │                     │
│  └────────────────────┬──────────────────┘                     │
│                       │                                        │
│                       ↓                                        │
│         ┌─────────────────────────────┐                       │
│         │ Already notified today?     │                       │
│         │ (Sync check - very fast)    │                       │
│         └────────────┬──────────────┬─┘                       │
│                  YES │              │ NO                      │
│                      │              │                        │
│              ┌───────↓──┐      ┌────↓──────────────┐         │
│              │ Return   │      │ Start ThreadJob   │         │
│              │ (skip)   │      │ (Background)      │         │
│              └──────────┘      └────┬─────────────┘         │
│                                     │                        │
│                                     ↓                        │
│                    ┌────────────────────────────┐             │
│                    │ Run check-update.ps1       │             │
│                    │ in Background              │             │
│                    │ - Check cache (6h window)  │             │
│                    │ - Call GitHub API if needed│             │
│                    │ - Parse response           │             │
│                    └────────┬───────────────────┘             │
│                             │                                 │
│                    ↓        │        ↑                        │
│         ┌──────────────────────────┐                         │
│         │ Profile Finishes         │                         │
│         │ (PROMPT READY)           │                         │
│         │ User can type            │                         │
│         └──────────────────────────┘                         │
│                                  │                            │
│              Meanwhile:          │      ↓                     │
│              Job still running    │  Toast appears            │
│              (Network call)       │  (if update found)        │
│                                  │  No wait!                 │
│                                  │                            │
│                                  ↓                            │
│                         ┌──────────────────┐                 │
│                         │ Notification     │                 │
│                         │ Async fired      │                 │
│                         └──────────────────┘                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## 🏗️ Arquitetura de Componentes

```
┌──────────────────────────────────────────────────────────────────┐
│                        CYBERPUNK TERMINAL                        │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ PROFILE (Microsoft.PowerShell_profile.ps1)               │  │
│  │                                                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ 1. PSReadLine Configuration (History/Colors)   │   │  │
│  │  │    - Syntax highlighting                        │   │  │
│  │    │ - Keyboard shortcuts                          │   │  │
│  │  │ - Persistent history (20k commands)            │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ 2. Custom Commands (hist, hfind, ls)           │   │  │
│  │  │    - Custom file listing with icons             │   │  │
│  │  │ - History search functions                      │   │  │
│  │  │ - Color conversion utilities                    │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ 3. oh-my-posh Initialization                   │   │  │
│  │  │    - Prompt theme rendering                     │   │  │
│  │  │ - Git status display                            │   │  │
│  │  │ - Language/framework indicators                 │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ 4. Async Update Check (ThreadJob)              │   │  │
│  │  │    - Non-blocking background job                │   │  │
│  │  │ - Fast return to prompt                         │   │  │
│  │  │ - Event-driven notification                     │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  │  ┌──────────────────────────────────────────────────┐   │  │
│  │  │ 5. Configuration Loading                       │   │  │
│  │  │    - Theme: cyberpunk-clean.omp.json            │   │  │
│  │  │ - Rules: cyber-item-rules.psd1 (icons/colors)  │   │  │
│  │  │ - Rules applied to file listing                 │   │  │
│  │  └──────────────────────────────────────────────────┘   │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ SCRIPTS DIRECTORY (Supporting Scripts)                  │  │
│  │                                                          │  │
│  │  • check-update.ps1                                     │  │
│  │    └─ GitHub API integration                           │  │
│  │    └─ Cache management (6h window)                     │  │
│  │    └─ Version comparison logic                         │  │
│  │    └─ Called by profile via ThreadJob                 │  │
│  │                                                          │  │
│  │  • check.ps1                                            │  │
│  │    └─ Installation validation                          │  │
│  │    └─ Dependency verification                          │  │
│  │    └─ JSON syntax checking                             │  │
│  │                                                          │  │
│  │  • uninstall-checklist.ps1                             │  │
│  │    └─ Visual checklist display                         │  │
│  │    └─ Interactive removal confirmation                 │  │
│  │    └─ Automatic backup creation                        │  │
│  │                                                          │  │
│  │  • test-uninstall-verify.ps1                           │  │
│  │    └─ Post-uninstall validation                        │  │
│  │    └─ Checks all components removed                    │  │
│  │                                                          │  │
│  │  • performance-analysis.ps1                            │  │
│  │    └─ Benchmarking & profiling                         │  │
│  │    └─ Thresholds monitoring                            │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ DATA DIRECTORY (Configuration & Rules)                  │  │
│  │                                                          │  │
│  │  • cyber-item-rules.psd1                                │  │
│  │    └─ Icon mappings (.ps1 → 󰨊, .json → , etc)        │  │
│  │    └─ Color rules (node_modules → red, etc)            │  │
│  │    └─ File type patterns                                │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ THEMES DIRECTORY (oh-my-posh Themes)                    │  │
│  │                                                          │  │
│  │  • cyberpunk-clean.omp.json                             │  │
│  │    └─ Neon color scheme                                 │  │
│  │    └─ Git status display                                │  │
│  │    └─ Segment configuration                             │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │ TERMINAL CONFIGURATION (Windows Terminal)               │  │
│  │                                                          │  │
│  │  • windows-terminal-snippet.json                        │  │
│  │    └─ Profile configuration snippet                     │  │
│  │    └─ Font & appearance settings                        │  │
│  │    └─ Color scheme setup                                │  │
│  │                                                          │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

---

## 📈 Lifecycle Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                  USER JOURNEY & INTERACTION                     │
│                                                                 │
│  1. INSTALLATION PHASE                                          │
│     ┌──────────────────────────────────────────────────┐        │
│     │ $ .\install.ps1                                 │        │
│     │                                                 │        │
│     │ → Check prerequisites (PowerShell 7, oh-my-posh)│        │
│     │ → Backup existing profile                       │        │
│     │ → Copy profile, theme, data files               │        │
│     │ → Configure Windows Terminal (optional)         │        │
│     │ → Installation complete                         │        │
│     │                                                 │        │
│     │ ✓ First terminal opening ready!                │        │
│     └──────────────────────────────────────────────────┘        │
│                           ↓                                     │
│  2. FIRST TERMINAL OPENING                                      │
│     ┌──────────────────────────────────────────────────┐        │
│     │ Terminal loads profile                          │        │
│     │                                                 │        │
│     │ Phase 1 (Fast):                                 │        │
│     │  ├─ PSReadLine setup (~50ms)                   │        │
│     │  ├─ Custom functions registration (~30ms)       │        │
│     │  ├─ Color conversion (~20ms)                    │        │
│     │  ├─ Rules loading (~40ms)                       │        │
│     │  └─ oh-my-posh init (~100ms)                   │        │
│     │                                                 │        │
│     │ Phase 2 (Background):                           │        │
│     │  └─ Start ThreadJob for update check            │        │
│     │     (doesn't block - returns immediately)       │        │
│     │                                                 │        │
│     │ PROMPT APPEARS (Total: ~240ms)                 │        │
│     │                                                 │        │
│     │ Meanwhile in background:                        │        │
│     │  • Job runs check-update.ps1                    │        │
│     │  • Checks cache (6h window)                     │        │
│     │  • If no cache, queries GitHub API              │        │
│     │  • Compares versions                            │        │
│     │  • If update found: Toast notification          │        │
│     │                                                 │        │
│     │ Result: User has responsive terminal            │        │
│     └──────────────────────────────────────────────────┘        │
│                           ↓                                     │
│  3. DAILY USAGE                                                 │
│     ┌──────────────────────────────────────────────────┐        │
│     │ $ ls                   → See files with icons    │        │
│     │ $ hist -Search git     → Find command in history │        │
│     │ $ hfind docker         → Quick history search    │        │
│     │ $ update-check         → Manual update check     │        │
│     │ $ update-check -Force  → Force refresh (no cache)│        │
│     │                                                 │        │
│     │ All with neon cyberpunk colors!                 │        │
│     └──────────────────────────────────────────────────┘        │
│                           ↓                                     │
│  4. UPDATE SCENARIO                                             │
│     ┌──────────────────────────────────────────────────┐        │
│     │ New version released on GitHub                  │        │
│     │                                                 │        │
│     │ → Automatic check (next terminal opening)       │        │
│     │ → Toast notification appears                    │        │
│     │ → User runs: $ .\update.ps1                     │        │
│     │ → Script pulls latest, reinstalls               │        │
│     │ → New features available!                       │        │
│     └──────────────────────────────────────────────────┘        │
│                           ↓                                     │
│  5. UNINSTALLATION PHASE                                        │
│     ┌──────────────────────────────────────────────────┐        │
│     │ $ .\uninstall.ps1 -WithChecklist               │        │
│     │                                                 │        │
│     │ → Visual checklist shows what will be removed   │        │
│     │ → User confirms removal                         │        │
│     │ → Automatic backup created                      │        │
│     │ → Profile, theme, data removed                  │        │
│     │ → Temp files cleaned up                         │        │
│     │                                                 │        │
│     │ ✓ Clean removal with backup available!          │        │
│     │ → Run: $ .\scripts\test-uninstall-verify.ps1    │        │
│     │ → Confirms complete removal                     │        │
│     └──────────────────────────────────────────────────┘        │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🔄 Data Flow Diagram

```
┌────────────────────────────────────────────────────────────────┐
│                     DATA FLOW & CACHING                        │
│                                                                │
│  UPDATE CHECK FLOW:                                            │
│                                                                │
│  check-update.ps1 called                                       │
│         ↓                                                      │
│  Read VERSION file (local)                                     │
│         ↓                                                      │
│  Check cache file: cyberpunk-last-update-check.txt             │
│         ↓                                                      │
│    ┌────┴─────────────────┐                                  │
│    │                      │                                  │
│    ↓ Cache exists         ↓ No cache or -Force             │
│    AND age < 6h?          │                                  │
│    │                      │                                  │
│    YES                    NO                                 │
│    ├─────────┐            │                                  │
│    │          │            ↓                                  │
│    │          │     Call GitHub API                          │
│    │          │     (Invoke-RestMethod)                      │
│    │          │            │                                  │
│    │          │            ↓                                  │
│    │          │     Parse JSON response                      │
│    │          │     Extract latest version                   │
│    │          │            │                                  │
│    │          │            ↓                                  │
│    │          │     Write cache file with:                   │
│    │          │     - Latest version                         │
│    │          │     - Last check timestamp                   │
│    │          │     - Update available (Y/N)                 │
│    │          │            │                                  │
│    └──────────┴────────────┘                                  │
│              ↓                                                 │
│     Return result to Check-CyberUpdate                        │
│              ↓                                                 │
│     If update available:                                      │
│     - Show Toast notification (Windows 10+)                  │
│     - Or console fallback message                             │
│     - Write notification date to file                         │
│       (so we only notify once per day)                        │
│                                                               │
└────────────────────────────────────────────────────────────────┘

CACHE BEHAVIOR:

Window: 6 hours (360 minutes)

Before: User → check-update.ps1 → GitHub API (every call)
        Slow + Rate limited

After:  User → check-update.ps1 → Cache hit (fast return)
                                 └→ Miss → GitHub API → Cache update
        Responsive + API rate limit respected
```

---

## 🎯 Performance Optimization Strategy

| Component | Before | After | Improvement |
|-----------|--------|-------|-------------|
| **Profile Load** | ~500ms (sync subprocess) | ~240ms (async job) | **52% faster** |
| **Update Check** | 10s timeout + 5s probe | 5s timeout only | **50% faster** |
| **Cache Usage** | Never read | 6h window | **Instant for cached** |
| **Prompt Readiness** | Blocked by check | Background job | **Non-blocking** |
| **Network Call** | Required every time | Only when cache miss | **Up to 6h saved** |

---

## 📋 Component Responsibilities

| Component | Responsibility | Triggers |
|-----------|-----------------|----------|
| **install.ps1** | Installation orchestration | Manual: `.\install.ps1` |
| **Microsoft.PowerShell_profile.ps1** | Profile configuration & initialization | Auto: PowerShell startup |
| **check-update.ps1** | Version checking & cache management | ThreadJob (profile) or manual |
| **check.ps1** | Installation validation | Manual: `.\scripts\check.ps1` |
| **uninstall.ps1** | Removal orchestration | Manual: `.\uninstall.ps1` |
| **uninstall-checklist.ps1** | Interactive uninstall UI | Manual via `-WithChecklist` flag |
| **test-uninstall-verify.ps1** | Post-removal validation | Manual: `.\scripts\test-uninstall-verify.ps1` |
| **performance-analysis.ps1** | Benchmarking & profiling | Manual: `.\scripts\performance-analysis.ps1` |
| **cyber-item-rules.psd1** | Icon & color configuration | Loaded by profile |
| **cyberpunk-clean.omp.json** | Prompt theme configuration | Loaded by oh-my-posh |

---

## 🔐 Security & Backup Strategy

```
INSTALLATION:
  Original Profile → [backup]
                  └─> New Cyberpunk Profile (REPLACES original)

UNINSTALLATION:
  Cyberpunk Profile → [backup-timestamp]
                   └─> Can restore if needed
```

**Backup Locations:**
- During install: `$PROFILE.backup-before-install-{timestamp}`
- During uninstall: `{ProfileDir}/cyberpunk-backup-{timestamp}/`

**Cleanup:**
- Automatic temp file cleanup on uninstall
- User can restore from backup anytime
- Version file provides rollback capability

---

## 🚀 Future Enhancement Areas

| Area | Current | Potential |
|------|---------|-----------|
| **Update Notification** | Toast (Windows 10+) | Push to mobile? Webhook? |
| **Performance** | 240ms profile load | <100ms goal |
| **Cache** | 6h window | User-configurable |
| **Theme** | cyberpunk-clean only | Theme selector? |
| **Commands** | ls, hist, hfind, update-check | More custom commands? |
| **Plugin Support** | None | PowerShell module marketplace? |

---

**Última atualização:** 2026-06-20  
**Versão do projeto:** 2.2.0  
**Diagrama Status:** Visual flow documented with Excalidraw
