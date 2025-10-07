# WaitMed

WaitMed is a Flutter mobile app designed to help users find nearby hospitals in real time, see crowd levels, and get direction assistance. Users can also submit crowd level reports for hospitals, aiding smarter decision making when seeking medical care.

---

## 📌 Table of Contents

- [Features](#features)  
- [Tech Stack](#tech-stack)  
- [Architecture & Modules](#architecture--modules)  
- [Getting Started](#getting-started)  
  - [Prerequisites](#prerequisites)  
  - [Setup & Run](#setup--run)  
- [Folder Structure](#folder-structure)  
- [How It Works](#how-it-works)  
- [Future Enhancements](#future-enhancements)  
- [Contributing](#contributing)  
- [License](#license)  

---

## 🚀 Features

- Search hospitals by name or location  
- Display search results as markers on a map  
- Show user’s current location  
- Submit crowd-level reports for hospitals  
- Navigation & map interactions (zoom, pan)  
- Modular, maintainable, and scalable architecture  

---

## 🧰 Tech Stack

- **Flutter** — UI & cross-platform app  
- **flutter_map & latlong2** — for map rendering & geographic computations  
- **GetX** — state management & navigation  
- **HTTP (Dart)** — to call APIs (e.g. Nominatim)  
- **Geolocator** — for getting user location  
- **Firebase** (if used) — analytics, authentication, backend (if present)  

---

## 🏗 Architecture & Modules

WaitMed follows a modular structure:

- **models/** — data models like `Hospital`  
- **services/** — API & data fetch logic (e.g. hospital search)  
- **controllers/** — application logic (state, map control)  
- **widgets/** — reusable UI components (search bar, hospital marker, loading indicator)  
- **screens/** — full screen UIs (map screen, submit crowd report screen)  
- **core/** — theming, constants  

This separation keeps UI, logic, and data decoupled and easier to maintain.

---

## 🛠 Getting Started

### Prerequisites

Make sure you have:

- Flutter SDK installed (>= stable release)  
- Dart  
- An emulator or physical device  
- Internet access (for map tiles, APIs)  

### Setup & Run

Install dependencies

flutter pub get


Configure APIs / Permissions

Add location permissions in AndroidManifest.xml / Info.plist

If using any API keys (e.g. Google Maps, Firebase), add them accordingly

Ensure internet permission is allowed

Run the app

flutter run

1. **Clone the repository**

   git clone https://github.com/SOHAM-THUMMAR/wait_med.git
   cd wait_med

## 🗂 Folder Structure

Here’s a simplified view:

lib/
├── core/
├── controllers/
├── models/
├── services/
├── widgets/
├── screens/
└── main.dart


Each folder has isolated responsibilities (UI vs logic vs data).

## 🔍 How It Works

On the map screen, the user sees base hospital markers and their current location.

The user taps the search bar and submits a search term (e.g. “Apollo Hospital”).

The app calls the Nominatim API (or other) to fetch hospital locations matching the query.

It converts those into Hospital models, updates the controller state.

Markers are rebuilt via the HospitalMarker widget.

When tapping a marker, the user navigates to SubmitCrowdLevelScreen to view or submit crowd info.##

## 📈 Future Enhancements

Show a scrollable list of search results under the search bar

Add filters (hospital type, distance, open hours)

Use Google Places API (for better data)

Implement offline caching for maps / hospital data

Add user authentication & personalized history

Display crowd trends / statistics

Add directions / routing to a selected hospital

## 👥 Contributing

Fork the repo

Create a feature branch (git checkout -b feature/your-feature)

Make your changes & commit (git commit -m "Feature: …")

Push to your fork (git push origin feature/your-feature)

Open a Pull Request

Please make sure code is clean, modular, and tested.
