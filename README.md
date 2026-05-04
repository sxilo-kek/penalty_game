# Penalty Game 🥅⚽

A standalone Flutter/Flame penalty-kick game targeting **Flutter Web**.

## Project Structure

```
penalty_game/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── screens/
│   │   └── game_screen.dart         # GameWidget host
│   └── game/
│       ├── penalty_game.dart        # Core FlameGame + input
│       ├── ball.dart                # Ball physics & collision
│       ├── goalkeeper.dart          # Goalkeeper AI
│       ├── goal_area.dart           # Goal trigger zone
│       ├── blocker.dart             # Moving blockers (higher levels)
│       ├── aim_indicator.dart       # Drag aim/power visualiser
│       ├── flash.dart               # Full-screen goal/save flash
│       ├── secure_score.dart        # Tamper-resistant score wrapper
│       ├── hud_overlay.dart         # In-game HUD (score + level)
│       └── game_over_overlay.dart   # Game Over modal + restart
├── web/
│   └── index.html
├── assets/
│   └── images/
│       ├── field.png          ← Add your pitch background
│       ├── ball.png           ← Add your ball sprite
│       ├── goalkeeper.png     ← Add your goalkeeper sprite
│       └── blocker.png        ← Add your blocker sprite
└── pubspec.yaml
```

## Required Assets

Place the following PNG images in `assets/images/`:

| File | Description |
|------|-------------|
| `field.png` | Pitch background (fills screen) |
| `ball.png` | Football sprite (~34×34 px) |
| `goalkeeper.png` | Keeper sprite (~92×72 px) |
| `blocker.png` | Blocker obstacle sprite (~54×60 px) |

## Getting Started

```bash
# 1. Install dependencies
flutter pub get

# 2. Run in Chrome (development)
flutter run -d chrome

# 3. Build for production web
flutter build web --release
# Output lands in build/web/
```

## Gameplay

- **Drag** anywhere on screen to aim — drag direction opposite to shoot direction.
- **Release** to shoot; the further the drag the more power.
- Score as many **Goals** as possible before the keeper saves one.
- Difficulty increases every 3 goals — more blockers and a faster keeper.

## Key Changes vs Original (icoke2)

| Original | This project |
|----------|-------------|
| `sessionToken` parameter | Removed — standalone |
| `ScoreSigner` checksum | Removed — not needed |
| `GameScreen` required token | No token required |
| `GameOverOverlay` pops Navigator with result | Calls `game.restartGame()` |
| Package `icoke2` imports | All imports use `penalty_game` |
| `Flash` lived in `models/flash.dart` | Moved to `game/flash.dart` |
