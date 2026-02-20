# PillPrompt

Medication reminder app (offline-first, no login) with reliable local notifications and clean, accessible UI.

## Features

### Core UI

- Splash screen, profile setup, home, add/edit medicine, history, settings
- Light and dark themes with the CalmDose visual style and consistent typography (Google Fonts)
- Empty states, loading states, and reusable cards/section headers

### Medicine Management

- Add, edit, delete medicines
- Time-based schedules with multiple times per day
- Before/after food toggle, active/inactive toggle
- Start and end dates with validation
- Specific days selection for weekly schedules

### Local Data Layer (SQLite)

- Medicines table with versioned schema (includes weekdays)
- Medicine logs table for Taken/Missed/Snoozed actions
- Repositories for medicines and logs with join queries

### Reminders & Notifications

- Local notifications scheduled per dose time
- Specific-day scheduling with day-of-week recurrence
- Snooze scheduling
- Android notification actions for Taken and Snooze
- Notification permissions handling

### History & Status

- Logs stored for Taken/Missed/Snoozed
- History screen with filters by medicine and date range
- Home screen shows per-time status based on today's logs

### Home Preview

- Week-view schedule preview with dose counts per day
- Daily medicine cards with per-time status rows

### Settings

- Theme toggle (light/dark) with persistence
- Language switcher (English, German)
- Notification permission status and action

### Multi-Language Support

- English and German localizations via Flutter's `intl` / ARB files
- Localized strings across all screens

### User Feedback

- Snackbar notifications for add, update, and delete actions

## Tech Stack

| Layer            | Library                                |
| ---------------- | -------------------------------------- |
| Framework        | Flutter (Dart SDK ^3.10.0)             |
| State Management | GetX                                   |
| Database         | SQLite (`sqflite`)                     |
| Notifications    | `flutter_local_notifications`          |
| Preferences      | `shared_preferences`                   |
| Fonts            | `google_fonts`                         |
| Date/Time        | `intl`, `timezone`, `flutter_timezone` |
| Localization     | `flutter_localizations`, ARB files     |

## Project Structure

```
lib/
├── app/                  # App config, theme, routes
│   ├── routes/           # GetX route definitions
│   └── theme/            # Colors, theme data
├── controllers/          # GetX controllers (medicine, log, settings)
├── core/
│   ├── constants/        # App and domain constants
│   ├── helpers/          # Date/time, notification, localization, snackbar helpers
│   └── widgets/          # Reusable UI components
├── data/
│   ├── db/               # SQLite database setup
│   ├── models/           # Medicine, MedicineLog, MedicineLogEntry
│   └── repositories/     # Data access layer
├── features/             # Feature screens
│   ├── history/          # History page
│   ├── home/             # Home page
│   ├── medicine/         # Medicine form page
│   ├── reminder/         # Reminder modal
│   ├── settings/         # Settings page
│   └── splash/           # Splash page
├── l10n/                 # Localization (ARB files, generated classes)
├── services/             # Notification service, settings service
└── main.dart
```

## Run

```bash
flutter run
```

## Known Issues

- iOS notification action buttons are not wired yet (Android only).
- Specific-day scheduling does not yet adjust existing schedules when days are edited in bulk.

## Next Steps

- Add "Missed" action button to notifications and handle in background.
- Add weekly calendar view with tap-through to daily list.
- Add weekday-aware rescheduling on edits and timezone changes.
