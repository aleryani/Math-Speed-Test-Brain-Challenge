# Math Speed Test – Brain Challenge

A production-ready, fully offline Flutter math game focused on quick mental calculations. Built with Flutter, Riverpod, Material 3, and localized for English and Arabic.

## Features

- Fast-paced question rounds across Easy, Medium, and Hard difficulties
- 30s or 60s timers with streak bonuses for consistent correct answers
- Offline Daily Challenge generated from the current date for a deterministic 10-question set
- Persistent best score, difficulty, timer, theme, language, and sound preferences via `shared_preferences`
- Material 3 visual design with smooth AnimatedSwitcher, AnimatedOpacity, and TweenAnimationBuilder transitions
- Optional UI sound effects via `audioplayers` (muteable) and haptics-ready feedback overlay
- Full RTL support for Arabic, including localized strings through `intl`
- 100% ad-free offline experience

## Project Structure

```
lib/
  app.dart
  main.dart
  core/
    services/
    utils/
  features/
    home/
    game/
    results/
    settings/
    daily/
  theme/
  widgets/
```

## Getting Started

1. **Install Flutter 3.22+** and ensure the Android SDK is set up.
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app on an Android device or emulator:
   ```bash
   flutter run
   ```
4. Build a release APK:
   ```bash
   flutter build apk --release
   ```

## Offline Experience

- The game is fully offline. All math questions, daily challenges, and persistence are handled locally.
- No ads or network connectivity are required for the full experience.

## Assets

Sound effects are located under `assets/sfx/`:
- `tap.mp3`
- `correct.mp3`
- `wrong.mp3`

Ensure these assets remain small and user-friendly. Sounds fail gracefully if assets are unavailable.

## Testing

Automated tests are located in the `test/` directory:
- Question generation validation
- Widget smoke tests for navigation and RTL layout

Run the suite with:
```bash
flutter test
```

## Screenshots

Capture updated screenshots (home, gameplay, results, settings) after visual changes for store listings. Recommended command:
```bash
flutter emulators --launch <emulator>
flutter run
```
Then take device screenshots manually.

## License

This project is distributed for educational purposes and is not published on app stores by default. Adapt as needed for production deployments.
