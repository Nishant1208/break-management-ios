# BreakApp

A native iOS app where users can log in, complete a skills questionnaire, and view or manage their break session. Built with Swift and Firebase (Authentication + Firestore) for the backend.

Table of Contents: [Features](#features) · [Requirements](#requirements) · [Project Structure](#project-structure) · [Firebase Access](#firebase-access-for-reviewers) · [Installation](#installation--run) · [Test Credentials](#test-credentials) · [Firestore Data](#firestore-data-structure) · [App Flow](#app-flow) · [Architecture](#architecture-overview)

## Features

- Email/password login via Firebase Auth
- Skills questionnaire; answers are stored in Firestore
- Break screen with active timer, option to end break early, and ended state
- Last screen (Login, Questionnaire, or Break) is restored when you relaunch the app
- Dedicated logout button with confirmation

## Requirements

- Xcode 16.x or later
- iOS 18.4+
- Apple Developer account only if you want to run on a real device; Simulator is fine without it

## Project Structure

```
BreakApp/
├── App/
│   ├── AppDelegate.swift
│   ├── SceneDelegate.swift
│   └── AppCoordinator.swift
├── Data/
│   └── Repositories/
│       ├── FirebaseAuthRepository.swift
│       └── FirestoreDataRepository.swift
├── Domain/
│   ├── Models/
│   └── Protocols/
├── Presentation/
│   ├── Login/
│   ├── Questionnaire/
│   └── Break/
├── GoogleService-Info.plist
└── Info.plist
```

Dependencies are via Swift Package Manager (Firebase iOS SDK).

## Firebase Access (for reviewers)

The app is already wired to a Firebase backend. You don’t need to create or configure a Firebase project.

You’ve been given Editor access to the Firebase project (your email was added under Users and permissions). You can open the [Firebase Console](https://console.firebase.google.com/), open this project, and look at Authentication (users) and Firestore (collections `questionnaire_responses` and `breaks` — see Firestore Data below).

GoogleService-Info.plist is in this repo so you can build and run straight away without any Firebase setup.

## Installation & Run

1. Clone the repo:
   ```bash
   git clone https://github.com/YOUR_USERNAME/BreakApp.git
   cd BreakApp
   ```

2. Open BreakApp.xcodeproj in Xcode. If it asks, let it resolve Swift Package Manager dependencies (or use File → Packages → Resolve Package Versions).

3. Pick the BreakApp scheme and a simulator/device (iOS 18.4+), then Run (⌘R).

No CocoaPods or extra config. Clone, open, run.

## Test Credentials

Use this account for testing:

| Field    | Value          |
|----------|----------------|
| Email    | test@test.com  |
| Password | 123456         |

This user already exists in the Firebase project. Any other email/password will get a login error from Firebase, which is expected.

## Firestore Data Structure

Collection: questionnaire_responses

- Document ID is the userId (Firebase Auth UID).
- Fields: userId, selectedTasks, hasSmartphone, hasUsedGoogleMaps, canGetPhone (optional), submittedAt (timestamp).
- Used to see if the user has submitted the questionnaire and to store their answers.

Collection: breaks

- Document ID is the userId.
- Fields: start_time (timestamp), duration (number, seconds), ended_early (bool), actual_end_time (timestamp, optional).
- Used for the current break session and “end break early”.

With Editor access you can open Firebase Console → Firestore Database to inspect these.

## App Flow

- On launch: if not logged in you see Login; if logged in we restore the last screen (Login, Questionnaire, or Break), or default to Questionnaire if they haven’t submitted yet, else Break.
- Login: use test@test.com / 123456 → you go to Questionnaire (or Break if they already submitted).
- Questionnaire: answer and continue → data is saved to Firestore → Break screen. Back goes to Login (and we remember that for next launch).
- Break: timer, “End my break” if you want (writes to Firestore), and Logout (top-right) with a confirmation, then back to Login.
- If you kill the app and reopen, we open the same screen you were on.

## Architecture Overview

AppCoordinator handles navigation and stores the last screen in UserDefaults so we can restore it. View models hold state and expose callbacks; view controllers bind to them and update the UI. Backend is behind protocols: AuthRepositoryProtocol / FirebaseAuthRepository for login, logout, and current user; DataRepositoryProtocol / FirestoreDataRepository for questionnaire and break data. Login and Questionnaire use XIBs; the Break screen is built in code. Views and view models are kept separate.

## Summary Checklist for Reviewers

1. Clone the repo and open BreakApp.xcodeproj in Xcode.
2. Resolve packages if needed, then build and run (no Firebase setup).
3. Log in with test@test.com / 123456 and go through Login → Questionnaire → Break → Logout.
4. Optionally use your Editor access to the Firebase project to check Authentication and Firestore (questionnaire_responses, breaks).

## License

This was built as an assignment. Use and evaluation as per the assignment terms.
