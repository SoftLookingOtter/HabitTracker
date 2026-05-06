# Habit Tracker

A modern SwiftUI habit tracking app built as a final project for iOS development studies.

## Features

- Create new habits
- Mark habits as completed for today
- Automatic streak calculation
- Delete habits
- Local data persistence using SwiftData
- Error handling with alerts
- Statistics screen with SwiftUI Charts
- Modern card-based UI inspired by Apple Health

## Built With

- SwiftUI
- SwiftData
- MVVM Architecture
- SwiftUI Charts
- Observation Framework (@Observable / @Bindable)

## Project Structure

HabitTracker-SaraLinden
│
├── Models/
│ └── Habit.swift
│
├── Views/
│ ├── ContentView.swift
│ ├── HabitRowView.swift
│ ├── AddHabitView.swift
│ └── StatisticsView.swift
│
├── ViewModels/
│ └── HabitViewModel.swift

## Functionality

### Habits
Users can:
- Add habits
- Mark habits as completed
- Track current streaks
- Remove habits

### Statistics
The statistics screen displays:
- Total habits
- Total completions
- Best streak
- Weekly completion chart

## Persistence

The app uses SwiftData for local persistence.  
All habits remain saved even after the app is closed.

## Architecture

The app follows the MVVM pattern:
- Models handle data
- ViewModels handle logic
- Views handle UI

This creates a cleaner and more maintainable structure.

## Author

Sara Lindén
