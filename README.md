# PillPrompt

Medication reminder app (offline-first, no login) with reliable local notifications and clean, accessible UI.

**What’s Implemented**
1. **Core UI Screens**
1. Splash screen, profile setup, home, add/edit medicine, history, settings
1. Light and dark themes with the CalmDose visual style and consistent typography
1. Empty states, basic loading states, and reusable cards/section headers

2. **Medicine Management**
1. Add, edit, delete medicines
1. Time-based schedules with multiple times per day
1. Before/after food toggle, active/inactive toggle
1. Start and end dates with validation
1. Specific days selection for weekly schedules

3. **Local Data Layer (SQLite)**
1. Medicines table with versioned schema (includes weekdays)
1. Medicine logs table for Taken/Missed/Snoozed actions
1. Repositories for medicines and logs with join queries

4. **Reminders & Notifications**
1. Local notifications scheduled per time
1. Specific-day scheduling with day-of-week recurrence
1. Snooze scheduling
1. Android notification actions for Taken and Snooze
1. Notification permissions handling

5. **History & Status**
1. Logs stored for Taken/Missed/Snoozed
1. History screen reads from DB
1. History filters by medicine and date range
1. Home screen shows per-time status based on today’s logs

6. **Home Preview**
1. Week-view schedule preview with dose counts per day
1. Daily medicine cards with per-time status rows

8. **Notification Actions**
1. Android notification actions for Taken and Snooze
1. Action handlers log events and schedule snooze

7. **Settings**
1. Theme toggle wired to persistence
1. Notification permission status and action

**Tech Stack**
1. Flutter + GetX
1. SQLite (`sqflite`)
1. Local notifications (`flutter_local_notifications`)
1. Shared preferences for theme persistence

**Run**
```bash
cd e:\App Portfolio\pillprompt
flutter run
```

**Known Issues**
1. iOS notification action buttons are not wired yet (Android only).
1. Specific-day scheduling does not yet adjust existing schedules when days are edited in bulk.

**Next Steps**
1. Add “Missed” action button to notifications and handle in background.
1. Add weekly calendar view with tap-through to daily list.
1. Add weekday-aware rescheduling on edits and timezone changes.
