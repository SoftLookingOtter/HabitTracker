# Habit Tracker

A modern SwiftUI habit tracking app built as a final project for iOS development studies.

The app helps users create daily habits, mark them as completed, and stay motivated by tracking streaks and weekly progress.

---

## Features

- Create new habits
- Mark habits as completed for today
- Automatic streak calculation
- Delete habits
- Local data persistence using SwiftData
- Error handling with alerts
- Statistics screen with SwiftUI Charts
- Weekly completion timeline with color-coded habits
- About screen with project information
- Modern card-based UI inspired by Apple Health

---

## Built With

- SwiftUI
- SwiftData
- MVVM Architecture
- SwiftUI Charts
- Observation Framework (`@Observable` / `@Bindable`)
- SF Symbols

---

## Project Structure

```text
HabitTracker
│
├── Models
│   └── Habit.swift
│
├── Views
│   ├── ContentView.swift
│   ├── HabitRowView.swift
│   ├── AddHabitView.swift
│   ├── StatisticsView.swift
│   └── AboutView.swift
│
├── ViewModels
│   └── HabitViewModel.swift
│
└── HabitTrackerApp.swift
```

---

## Functionality

### Habits

Users can:

- Add habits
- Mark habits as completed for the current day
- Track current streaks
- Remove habits

### Statistics

The statistics screen displays:

- Total number of habits
- Total completions
- Best current streak
- Top habit based on streak
- A weekly completion timeline using SwiftUI Charts

Each colored dot in the timeline represents a completed habit on a specific day.

### Persistence

The app uses SwiftData for local persistence.

All habits and completion dates remain saved even after the app is closed.

### Error Handling

The app validates user input before saving.

If the user tries to save an invalid habit or if a database operation fails, the app shows a clear error message instead of crashing.

---

## Architecture

The app follows the MVVM pattern:

- Models handle stored data and streak logic
- ViewModels handle app logic and database operations
- Views handle UI and user interaction

This creates a cleaner and more maintainable structure.

---

## VG Track

For the advanced functionality requirement, the app uses SwiftUI Charts to visualize habit history over the latest seven days.

---

## Future Improvements

Possible future features include:

- Notifications and reminders
- iCloud synchronization
- Habit categories
- Monthly statistics
- Dark mode customization
- Widgets and lock screen support

---

## Author

Sara Lindén
