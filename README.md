<<<<<<< HEAD
# TaskFlow - Smart Task Manager

TaskFlow is a personalized Flutter internship assignment project by **Vaibhav Kumar**, an aspiring software developer working with **Flutter, Firebase, and Dart**. The app focuses on clean task planning, Firebase-backed user data, a polished responsive interface, and practical productivity features.

## Features

- Firebase Authentication: signup, login, logout, forgot password
- Cloud Firestore task CRUD scoped per user
- Task fields: title, description, date, priority, category, status, createdAt
- Categories: Personal, Work, Study, Health
- Filters: all, pending, completed, high priority
- Search by task title, description, and category
- Motivational quote card from `https://api.quotable.io/random`
- Loading states, validation, snackbar feedback, and retry flows
- Swipe to delete, pull to refresh, empty state UI
- Dashboard statistics for total, pending, completed, and high priority tasks
- Light and dark themes with custom TaskFlow colors
- Local notification setup hook for task reminders
- Android and iOS ready Flutter structure

## Folder Structure

```text
lib/
├── constants/
├── models/
├── providers/
├── screens/
├── services/
├── themes/
├── utils/
├── widgets/
└── main.dart
```

## Firebase Setup

1. Create a Firebase project from the Firebase Console.
2. Enable Email/Password Authentication.
3. Create a Cloud Firestore database.
4. Add Android and iOS apps using your preferred package identifiers.
5. Download and place:
   - `android/app/google-services.json`
   - `ios/Runner/GoogleService-Info.plist`
6. Regenerate `lib/firebase_options.dart` with FlutterFire CLI if you change Firebase projects:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

## Installation

```bash
flutter pub get
flutter run
```

## APK

Build a release APK with:

```bash
flutter build apk --release
```

Place the final APK link or file path here after building:

```text
APK: pending
```

## Screenshots

Add screenshots after running the app:

```text
Splash Screen: pending
Login Screen: pending
Dashboard: pending
Task Editor: pending
Dark Theme: pending
```

## Demo Video

Add the demo video link here:

```text
Demo Video: pending
```

## Developer

**Vaibhav Kumar**  
Role: Aspiring Software Developer  
Tech Stack: Flutter, Firebase, Dart
=======
# taskflow-smart-task-manager
TaskFlow is a modern Flutter-based task management app with Firebase Authentication, Cloud Firestore CRUD, REST API integration, task filtering, notifications, and responsive UI. It helps users organize daily tasks efficiently with clean architecture and smooth user experience.
>>>>>>> 1d63fd5365d840852bca144cbd6e11a7ac6ae72f
