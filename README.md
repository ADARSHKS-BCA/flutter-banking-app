# SecureBank - Flutter Banking App

SecureBank is a modern, secure, and user-friendly banking application built with **Flutter**. It allows users to manage their finances, perform transactions, and track their history with a clean and intuitive interface.

## 🚀 Features

- **User Authentication**: Secure Login and Signup functionality using Firebase Auth.
- **Dashboard**: Real-time overview of your current balance and recent activities.
- **Money Operations**:
  - **Deposit**: Add funds to your account easily.
  - **Withdraw**: Transfer funds out of your account securely.
- **Transaction History**: Detailed list of all your past transactions.
- **Responsive Design**: Optimized for both Android and iOS devices.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/) (Dart)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **Backend/Auth**: [Firebase Authentication](https://firebase.google.com/docs/auth)
- **Local Storage**: [SharedPreferences](https://pub.dev/packages/shared_preferences)
- **Formatting**: [Intl](https://pub.dev/packages/intl)

## 📂 Project Structure

```
lib/
├── models/         # Data models (User, Transaction)
├── providers/      # State management logic (Auth, Bank)
├── screens/        # UI Screens
│   ├── auth/       # Login & Signup screens
│   ├── home/       # Dashboard
│   ├── history/    # Transaction logs
│   ├── operations/ # Deposit & Withdraw
│   └── splash_screen.dart
├── services/       # External services (Storage, API)
├── utils/          # Constants and utilities
├── widgets/        # Reusable UI components
└── main.dart       # Entry point
```

## 🏁 Getting Started

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/ADARSHKS-BCA/flutter-banking-app.git
    ```

2.  **Install dependencies:**
    ```bash
    flutter pub get
    ```

3.  **Run the app:**
    ```bash
    flutter run
    ```
