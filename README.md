# WaitMed

WaitMed is a Flutter-based mobile application designed to help users quickly find nearby hospitals, visualize them on a live map, and share real-time crowd information. The purpose of the app is to assist people in making faster and more informed decisions during medical emergencies or hospital visits.

---

## Features

- Search hospitals by name or keyword  
- Display hospitals as markers on an interactive map  
- Detect and show the user's live location  
- Allow users to submit crowd levels  
- View crowd data for each hospital  
- Smooth zoom and map navigation  
- Modular and scalable Flutter architecture  

---

## Tech Stack

- Flutter  
- Dart  
- GetX for state management  
- flutter_map for maps  
- latlong2 for coordinates  
- Geolocator for live location  
- HTTP for API calls  
- Firebase (optional backend support)  

---

## Folder Structure

```
lib/
├── core/              # Constants, themes
├── controllers/       # Logic and GetX controllers
├── models/            # Data models
├── services/          # APIs and network calls
├── widgets/           # Reusable UI widgets
├── screens/           # UI screens
└── main.dart          # Entry point
```

---

## Setup Guide

### Requirements

- Flutter SDK installed  
- Android Studio / VS Code  
- Emulator or real device  
- Internet connection  

---

### Installation Steps

Clone repository:
```bash
git clone https://github.com/SOHAM-THUMMAR/wait_med.git
cd wait_med
```

Install packages:
```bash
flutter pub get
```

Add Android location permissions:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
```

Add iOS location permission in Info.plist:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app requires location to find nearby hospitals.</string>
```

Run app:
```bash
flutter run
```

---

## App Workflow

1. Opens with a map centered on user's current position  
2. User searches hospitals  
3. API fetches hospital data  
4. Hospitals appear as map markers  
5. Users tap markers to check or submit crowd levels  

---

## Planned Enhancements

- Hospital list UI  
- Advanced filters  
- Navigation routing  
- Firebase live crowd syncing  
- Analytics dashboard  
- Offline storage  

---

## Contribution Steps

```bash
# Fork the repository
# Create a new branch
git checkout -b feature-name

# Commit changes
git commit -m "Added new feature"

# Push branch
git push origin feature-name
```

Then open a Pull Request on GitHub.
