# Moovie App (Flutter Chat UI)

Moovie App is a Flutter-based messaging application UI inspired by popular chat platforms. It demonstrates tab-based navigation for chats, status updates, calls, and camera functionality using Material Design components.

---

## 📱 App Overview

Moovie App focuses on building a **WhatsApp-like chat interface** using Flutter. The app is ideal for learning UI layout, tab navigation, and list-based views in Flutter.

### Main Features

* Chats list with recent messages and timestamps
* Status updates (My Status, Recent, Viewed)
* Camera screen placeholder
* Calls tab (UI structure)
* Floating Action Button for new chat actions
* Clean Material UI with AppBar & TabBar

---

## 🧭 Screens

### 💬 Chats

* Displays contacts and last messages
* Message indicators and timestamps
* Group and individual chat previews

### 📷 Camera

* Camera placeholder screen
* Tap-to-take-photo UI

### 🟢 Status

* My Status section
* Recent updates
* Viewed updates

### 📞 Calls

* Calls tab layout (UI-focused)

---

## 📂 Project Structure

```
lib/
 ├── main.dart
 ├── screens/
 │    ├── chats_screen.dart
 │    ├── status_screen.dart
 │    ├── calls_screen.dart
 │    └── camera_screen.dart
 ├── widgets/
 │    ├── chat_tile.dart
 │    ├── status_tile.dart
 │    └── custom_app_bar.dart

test/
 └── widget_test.dart
```

> File names may vary slightly depending on implementation.

---

## 🚀 Getting Started

### Prerequisites

* Flutter SDK (stable channel)
* Android Studio or VS Code
* Android Emulator or Physical Device

### Installation

1. Clone the repository

```bash
git clone https://github.com/your-username/moovie-app.git
```

2. Navigate into the project

```bash
cd moovie-app
```

3. Install dependencies

```bash
flutter pub get
```

4. Run the app

```bash
flutter run
```

---

## 🛠️ Built With

* **Flutter** (Dart)
* **Material Design**
* TabBar & TabBarView
* ListView & Custom Widgets

---

## 🎯 Purpose of This Project

* Practice Flutter UI development
* Learn tab-based navigation
* Build chat-style interfaces
* Educational / learning project

> ⚠️ This app is a UI demo only. No real messaging or backend integration is included.

---

## 📸 Screenshots

Create a folder named `screenshots/` in the project root and add your images:

```md
![Chats](screenshots/chats.png)
![Camera](screenshots/camera.png)
![Status](screenshots/status.png)
```

---

## 📄 License

This project is open-source and available for educational use.

---

## 👤 Author

**Wisdom Johnny**
Flutter Developer

---

⭐ Star the repository if you find this project helpful!
