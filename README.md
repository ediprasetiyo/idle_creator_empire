# Idle Creator Empire

An idle clicker game where you start as a beginner content creator and build your empire.

## Game Concept

Choose a creator career (Gaming, Horror, Food, Travel, Technology, Comedy, Education, Music) and tap your way to fame. Each career has unique icons, colors, upgrade names, and studio decorations — but identical core gameplay.

## Target

- Android only
- Flutter Stable
- Material Design 3
- Offline game (no internet required)
- No Firebase, no login, no API

---

## Folder Structure

```
lib/
├── main.dart                  # App entry point
├── app.dart                   # MaterialApp + theme + routing
│
├── models/
│   ├── career.dart            # Career enum + career-specific data
│   ├── player.dart            # Player state (coins, views, xp, level, followers)
│   ├── upgrade.dart           # Upgrade definitions + costs
│   ├── achievement.dart       # Achievement definitions + unlock conditions
│   └── prestige.dart          # Prestige data (creator stars, multiplier)
│
├── providers/
│   ├── game_provider.dart     # Core game state + tap logic + offline income
│   └── settings_provider.dart # Sound, theme, notification settings
│
├── screens/
│   ├── splash_screen.dart     # Loading + offline income popup
│   ├── career_screen.dart     # Career selection (first launch)
│   ├── home_screen.dart       # Main gameplay screen (tap + stats)
│   ├── upgrade_screen.dart    # Equipment + studio upgrades
│   ├── achievement_screen.dart# Achievements list
│   ├── prestige_screen.dart   # Prestige reset + creator stars
│   └── settings_screen.dart   # Settings + reset + about
│
├── widgets/
│   ├── tap_button.dart        # Animated tap-to-create button
│   ├── stats_bar.dart         # Top bar (coins, views, followers)
│   ├── coin_counter.dart      # Animated coin display
│   ├── upgrade_card.dart      # Single upgrade item card
│   ├── achievement_card.dart  # Single achievement item card
│   ├── studio_view.dart       # Visual studio decoration display
│   └── level_progress.dart    # XP progress bar + level badge
│
├── services/
│   ├── save_service.dart      # SharedPreferences read/write
│   ├── offline_service.dart   # Offline income calculation (max 8h)
│   └── ad_service.dart        # Google Mobile Ads wrapper (prepared)
│
└── utils/
    ├── constants.dart         # Game balance numbers + durations
    ├── formatters.dart        # Number formatting (1K, 1M, 1B)
    ├── career_data.dart       # Per-career icons, colors, names
    └── theme.dart             # Dark theme + Material 3 config

assets/
├── icons/                     # Career + UI icons
├── sounds/                    # Tap + upgrade + prestige sounds
└── animations/                # Lottie or sprite animations
```

---

## Recommended Packages

| Package | Version | Purpose |
|---|---|---|
| provider | ^6.1.2 | State management |
| shared_preferences | ^2.3.4 | Local save data |
| google_mobile_ads | ^5.2.0 | Ad monetization (prepared only) |
| flutter_animate | ^4.5.0 | Smooth UI animations |
| google_fonts | ^6.2.1 | Modern typography |
| shimmer | ^3.0.0 | Loading shimmer effects |
| audioplayers | ^6.1.0 | Sound effects |
| intl | ^0.19.0 | Number/date formatting |
| uuid | ^4.5.1 | Unique IDs for save data |

---

## Architecture

### Pattern: Provider + Service Layer

```
┌─────────────┐
│   Screens    │   UI layer — displays state, sends user actions
├─────────────┤
│   Widgets    │   Reusable UI components
├─────────────┤
│  Providers   │   State management — game logic, notifies UI
├─────────────┤
│  Services    │   Data layer — save/load, offline calc, ads
├─────────────┤
│   Models     │   Data classes — career, player, upgrade, etc.
├─────────────┤
│   Utils      │   Constants, formatters, theme, career data
└─────────────┘
```

**Data Flow:**
1. User taps → Screen calls Provider method
2. Provider updates state → notifyListeners()
3. Widgets rebuild with new state
4. Provider calls SaveService to persist changes
5. On app launch, SaveService loads data → Provider restores state
6. OfflineService calculates idle earnings from timestamp delta

**Key Decisions:**
- Single `GameProvider` holds all gameplay state (coins, views, xp, level, upgrades)
- Separate `SettingsProvider` for user preferences (sound, theme)
- `SaveService` wraps SharedPreferences with typed getters/setters
- All models are plain Dart classes (no code generation)
- No dependency injection framework — manual constructor injection

---

## Project Roadmap

### Phase 1 — Foundation
- [x] Project structure + pubspec.yaml
- [x] README + architecture docs
- [ ] Models (Career, Player, Upgrade, Achievement, Prestige)
- [ ] Theme + constants + career data
- [ ] SaveService (SharedPreferences wrapper)

### Phase 2 — Core Gameplay
- [ ] GameProvider (state + tap logic)
- [ ] Home screen (tap button + stats)
- [ ] Coin/view/XP gain per tap
- [ ] Level system (XP thresholds)
- [ ] Number formatting (1K, 1M, 1B)

### Phase 3 — Career Selection
- [ ] Career selection screen
- [ ] Per-career theming (icons, colors, names)
- [ ] First-launch flow → career pick → home

### Phase 4 — Upgrades
- [ ] Upgrade model + balance
- [ ] Upgrade screen UI
- [ ] Equipment upgrades (increase tap income)
- [ ] Studio upgrades (unlock decorations)
- [ ] Auto-income upgrades (idle earnings/sec)

### Phase 5 — Progression
- [ ] Achievement system
- [ ] Achievement screen UI
- [ ] Follower milestones
- [ ] Creator title progression
- [ ] Studio visual progression

### Phase 6 — Offline Income
- [ ] Timestamp save on app close
- [ ] Offline income calculation (max 8 hours)
- [ ] Splash screen with offline earnings popup

### Phase 7 — Prestige
- [ ] Prestige unlock at Level 50
- [ ] Creator Stars currency
- [ ] Permanent income multiplier
- [ ] Prestige screen + confirmation

### Phase 8 — Polish
- [ ] Animations (tap, upgrade, level up, prestige)
- [ ] Sound effects
- [ ] Settings screen (sound toggle, reset, about)
- [ ] Google Mobile Ads integration (prepared)
- [ ] Final UI polish + performance

---

## How to Run

```bash
flutter pub get
flutter run
```

---

## Tech Stack

- **Framework:** Flutter (Stable)
- **Language:** Dart
- **State:** Provider
- **Storage:** SharedPreferences
- **Design:** Material Design 3, Dark Theme
- **Ads:** Google Mobile Ads (prepared, not activated)
- **Platform:** Android only
