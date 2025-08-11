# 🐕 UAWS - Urban Animal Welfare System

**A comprehensive digital platform for urban animal welfare management, sterilization tracking, and public health monitoring.**

![Flutter](https://img.shields.io/badge/Flutter-3.19+-blue?logo=flutter)
![Firebase](https://img.shields.io/badge/Firebase-Integration-orange?logo=firebase)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-85%25_Complete-yellow)

---

## 📋 **Project Overview**

UAWS is a multi-platform digital solution designed to streamline urban animal welfare operations across India. The system provides role-based access for field staff, supervisors, municipal officials, and administrators to manage sterilization programs, vaccination tracking, bite case monitoring, and public health surveillance.

### **🎯 Key Features**

-   **4-Layer User Management** (Field Staff → Municipal Officials → NGO Supervisors → Admins)
-   **3-Stage Sterilization Tracking** (Pickup → Operation → Release)
-   **Comprehensive Vaccination Management** with due date calculations
-   **Bite Case & Quarantine Monitoring** for public safety
-   **Rabies Surveillance** and emergency response
-   **Education Initiative Tracking** for community outreach
-   **Automated Report Generation** for municipal compliance
-   **Offline-First Mobile App** for field operations
-   **Real-time Dashboard** for supervisors and administrators

---

## 🏗️ **Architecture**

### **Mobile App (Flutter)**

-   **Target Users:** Layer 1 (Field Staff - Catchers, Vaccinators, LSS)
-   **Platform:** Cross-platform (Android & iOS)
-   **Purpose:** Offline-first data collection for field operations

### **Web Dashboard (Next.js)** [Planned]

-   **Target Users:** Layer 2 (NGO Supervisors), Layer 2B (Municipal), Layer 3 (Admins)
-   **Platform:** Progressive Web App (PWA)
-   **Purpose:** Management, monitoring, and reporting system

---

## 🚀 **Getting Started**

### **Prerequisites**

-   Flutter 3.19+ installed
-   Android Studio / VS Code with Flutter extensions
-   Firebase project setup (for backend integration)
-   Git for version control

### **Installation**

1. **Clone the Repository**

    ```bash
    git clone https://github.com/azimshk/UAWS-Latest.git
    cd UAWS-Latest
    ```

2. **Install Dependencies**

    ```bash
    flutter pub get
    ```

3. **Firebase Setup** (Required for backend)

    ```bash
    # Add your google-services.json (Android) to android/app/
    # Add your GoogleService-Info.plist (iOS) to ios/Runner/
    ```

4. **Run the Application**

    ```bash
    # Debug mode
    flutter run

    # Release mode
    flutter run --release
    ```

### **Development Setup**

```bash
# Check Flutter installation
flutter doctor

# Run tests
flutter test

# Build for Android
flutter build apk

# Build for iOS
flutter build ios
```

---

## 📱 **Current Implementation Status**

### ✅ **Fully Implemented (85% Complete)**

#### **🔐 Authentication & User Management**

-   Firebase authentication with role-based access
-   4-layer user permission system
-   Secure login/logout with session management
-   Auto-logout and permission validation

#### **📊 Dashboard System**

-   **Admin Dashboard** - Layer 3 super admin access
-   **Municipal Dashboard** - Layer 2B read-only access
-   **Supervisor Dashboard** - Layer 2 operational access
-   **Field Dashboard** - Layer 1 data collection interface

#### **🏗️ Core Infrastructure**

-   GetX state management with reactive controllers
-   Complete English + Marathi localization
-   Material Design 3 theming
-   Comprehensive navigation and routing
-   Local storage and dummy data services

### 🟡 **Partially Implemented (70% Complete)**

-   Dashboard controllers with mock data (ready for Firebase integration)
-   User interface components and feedback systems
-   Navigation structure for all modules

### ❌ **Not Implemented (0% Complete)**

-   **Sterilization Tracker** (3-stage process)
-   **Vaccination Management** system
-   **Bite Case Tracking** for public safety
-   **Quarantine Monitoring** (10-day observation)
-   **Rabies Surveillance** system
-   **Education Initiative Tracker**
-   **Firebase Backend Integration**
-   **Camera & GPS Services**
-   **Offline Data Synchronization**
-   **Report Generation System**

---

## 📁 **Project Structure**

```
lib/
├── main.dart                           # App entry point
├── controllers/                        # GetX controllers
│   ├── admin_dashboard_controller.dart
│   ├── municipal_dashboard_controller.dart
│   ├── supervisor_dashboard_controller.dart
│   └── field_dashboard_controller.dart
├── core/
│   └── theme/
│       └── app_theme.dart             # Material Design theme
├── models/
│   └── user_model.dart                # User data models
├── screens/                           # UI screens
│   ├── admin_dashboard_screen.dart
│   ├── municipal_dashboard_screen.dart
│   ├── supervisor_dashboard_screen.dart
│   └── field_dashboard_screen.dart
├── services/                          # Business logic
│   ├── auth_service.dart              # Authentication
│   ├── dummy_data_service.dart        # Mock data
│   └── storage_service.dart           # Local storage
└── translations/
    └── app_translations.dart          # i18n support

# Missing Structure (To be implemented)
├── screens/sterilization/             # ❌ Not implemented
├── screens/vaccination/               # ❌ Not implemented
├── screens/bite_cases/                # ❌ Not implemented
├── screens/quarantine/                # ❌ Not implemented
├── screens/rabies/                    # ❌ Not implemented
├── screens/education/                 # ❌ Not implemented
├── models/sterilization_model.dart    # ❌ Not implemented
├── services/firebase_service.dart     # ❌ Not implemented
└── services/camera_service.dart       # ❌ Not implemented
```

---

## 🛠️ **Tech Stack**

### **Frontend**

-   **Flutter 3.19+** - Cross-platform mobile development
-   **GetX** - State management and reactive programming
-   **Material Design 3** - Modern UI components

### **Backend** [To be implemented]

-   **Firebase Suite**
    -   Firestore (NoSQL database)
    -   Firebase Auth (Authentication)
    -   Cloud Storage (File uploads)
    -   Cloud Functions (Server-side logic)

### **Key Dependencies**

```yaml
dependencies:
    flutter:
        sdk: flutter
    get: ^4.6.6 # State management
    firebase_core: ^2.24.2 # Firebase core
    firebase_auth: ^4.15.3 # Authentication
    cloud_firestore: ^4.13.6 # Database
    image_picker: ^1.0.4 # Camera integration
    geolocator: ^10.1.0 # GPS services
    sqflite: ^2.3.0 # Local database
    shared_preferences: ^2.2.2 # Local storage
```

---

## 🚧 **Development Roadmap**

### **Phase 1: Foundation (4 weeks)** 🔥

-   [ ] Firebase setup and integration
-   [ ] Sterilization tracker (3-stage process)
-   [ ] Photo and GPS capture
-   [ ] Real data persistence

### **Phase 2: Essential Modules (4 weeks)** 📱

-   [ ] Vaccination management system
-   [ ] Camera and GPS services
-   [ ] Offline data synchronization
-   [ ] SQLite local database

### **Phase 3: Safety & Surveillance (3 weeks)** 🏥

-   [ ] Bite case tracking
-   [ ] Quarantine monitoring (10-day)
-   [ ] Rabies surveillance system
-   [ ] Emergency response protocols

### **Phase 4: Reporting & Administration (2 weeks)** 📊

-   [ ] Education initiative tracker
-   [ ] PDF report generation
-   [ ] Automated scheduling
-   [ ] Final testing and deployment

**Total Estimated Timeline:** 13-15 weeks to full completion

---

## 👥 **User Roles & Permissions**

| Layer        | Role                | Access Level    | Key Functions                                        |
| ------------ | ------------------- | --------------- | ---------------------------------------------------- |
| **Layer 1**  | Field Staff         | Data Collection | Sterilization pickup, Vaccination, Photo/GPS capture |
| **Layer 2**  | NGO Supervisors     | Full Operations | Complete sterilization workflow, Team management     |
| **Layer 2B** | Municipal Officials | Read-Only       | Dashboard viewing, Report access, Statistics         |
| **Layer 3**  | Admins              | Super Admin     | User management, System config, Automated reports    |

---

## 🔧 **Configuration**

### **Firebase Setup**

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com)
2. Enable Authentication, Firestore, and Storage
3. Download configuration files:
    - `google-services.json` → `android/app/`
    - `GoogleService-Info.plist` → `ios/Runner/`

### **Environment Variables**

```bash
# Create .env file in project root
FIREBASE_PROJECT_ID=your_project_id
FIREBASE_API_KEY=your_api_key
FIREBASE_AUTH_DOMAIN=your_project.firebaseapp.com
```

---

## 📊 **Current Metrics**

-   **🏗️ Infrastructure:** 100% Complete
-   **🔐 Authentication:** 100% Complete
-   **📱 UI/UX:** 100% Complete
-   **🎮 Controllers:** 70% Complete (mock data)
-   **🔥 Backend Integration:** 0% Complete
-   **📋 Core Modules:** 0% Complete
-   **📱 Mobile Features:** 0% Complete

**Overall Progress:** 85% Foundation + 0% Core Features = **~42% Total**

---

## 🤝 **Contributing**

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch** (`git checkout -b feature/amazing-feature`)
3. **Commit changes** (`git commit -m 'Add amazing feature'`)
4. **Push to branch** (`git push origin feature/amazing-feature`)
5. **Open a Pull Request**

### **Development Guidelines**

-   Follow [Flutter Style Guide](https://dart.dev/guides/language/effective-dart/style)
-   Write unit tests for new features
-   Update documentation for API changes
-   Use meaningful commit messages

---

## 📄 **Documentation**

-   **[Project Completion Analysis](PROJECT_COMPLETION_ANALYSIS.md)** - Detailed status report
-   **[Mobile App Specification](UAWS_Mobile_App_Specification.md)** - Field app requirements
-   **[Web Dashboard Specification](UAWS_Web_Dashboard_Specification.md)** - Management system specs
-   **[Sterilization Tracker Guide](UAWS_Sterilization_Tracker.md)** - Core module documentation
-   **[User Guide](USERS_GUIDE.md)** - End-user documentation

---

## 🐛 **Known Issues**

-   [ ] Mock data used in all controllers (requires Firebase integration)
-   [ ] Navigation routes commented out (awaiting screen implementation)
-   [ ] Camera and GPS services not implemented
-   [ ] Offline synchronization not available

---

## 📞 **Support**

-   **Issues:** [GitHub Issues](https://github.com/azimshk/UAWS-Latest/issues)
-   **Discussions:** [GitHub Discussions](https://github.com/azimshk/UAWS-Latest/discussions)
-   **Email:** azimshk@gmail.com

---

## 📜 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 **Acknowledgments**

-   Flutter team for the amazing framework
-   Firebase for backend infrastructure
-   GetX for state management
-   Material Design team for UI guidelines
-   Animal welfare organizations for requirements and feedback

---

**Built with ❤️ for Urban Animal Welfare**

_Last Updated: August 11, 2025_
