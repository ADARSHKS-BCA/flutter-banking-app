# 🏦 SecureBank - Full Stack Banking Application

**SecureBank** is a modern, premium banking application capable of handling real-time transactions, user authentication, and account management. It features a stunning **Flutter** frontend connected to a robust **Django REST Framework** backend.

## 🌟 Key Features

### 📱 Frontend (Flutter)
- **Modern UI/UX**: Premium aesthetic with glassmorphism, gradients, and smooth animations.
- **Secure Authentication**: Login and Registration system integrated with Django Backend.
- **Dashboard**: Real-time balance updates and account details.
- **Operations**: 
  - **Deposit**: Add funds securely.
  - **Withdraw**: Manage cash flow with validated limits.
  - **Transfer**: Send money to other users instantly.
- **Transaction History**: Comprehensive log of all account activities.
- **Profile Management**: View and manage account details.

### 🔙 Backend (Django)
- **RESTful API**: Built with Django Rest Framework (DRF).
- **Security**: JWT-based authentication (or Token-based).
- **Database**: PostgreSQL (Production) / SQLite (Development).
- **Deployment**: Fully hosted on **Render**.

---

## 🛠️ Technology Stack

| Component | Technology | Description |
|-----------|------------|-------------|
| **Frontend** | Flutter (Dart) | Cross-platform mobile/web UI |
| **State** | Provider | Efficient state management |
| **Backend** | Django & DRF | Python-based robust API server |
| **Database** | PostgreSQL | Reliability and data integrity |
| **Hosting** | Render | Cloud deployment |

---

## 📂 Project Structure

This is a Monorepo containing both client and server code.

```bash
flutter-banking-app/
├── lib/                 # 📱 Flutter Frontend Code
│   ├── screens/         # UI Pages (Home, Auth, Operations)
│   ├── providers/       # State Logic (BankProvider, AuthProvider)
│   ├── services/        # API Integration (ApiService)
│   └── widgets/         # Reusable Components
│
├── bc_securebank/       # 🔙 Django Backend Code
│   ├── banking_app/     # Core Banking Logic (Models, Views)
│   ├── manage.py        # Django Entry Point
│   └── requirements.txt # Python Dependencies
│
└── pubspec.yaml         # Flutter Dependencies
```

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- [Python 3.10+](https://www.python.org/downloads/)
- [PostgreSQL](https://www.postgresql.org/) (optional for local dev, can use SQLite)

### 1️⃣ Backend Setup (Django)

Navigate to the backend directory:
```bash
cd bc_securebank
```

Install dependencies:
```bash
pip install -r requirements.txt
```

Run migrations and start server:
```bash
python manage.py migrate
python manage.py runserver
```
*The API will be available at `http://127.0.0.1:8000/api`*

### 2️⃣ Frontend Setup (Flutter)

Navigate to the project root (where `pubspec.yaml` is):
```bash
flutter pub get
```

Run the app:
```bash
flutter run
```
*Note: The app is currently configured to point to the **Production Backend** (`https://flutter-banking-app.onrender.com/api`). To use local backend, check `lib/services/api_service.dart`.*

---

## 🌍 Deployment

The backend is deployed and live on **Render**.

- **API Base URL**: `https://flutter-banking-app.onrender.com`
