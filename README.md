# EShops - Flutter E-Commerce Application

A modern, feature-rich e-commerce mobile application built with Flutter, implementing clean architecture with BLoC state management.

## 🚀 Features

### Authentication
- User registration and login
- Secure session management
- Role-based access (Admin/Seller)

### Dashboard
- **Admin Dashboard**: Manage sellers, view analytics
- **Seller Dashboard**: Manage products, view sales data
- Real-time data updates with BLoC pattern

### Product Management
- Add/Edit products
- Product catalog with search and filtering
- Image uploads and management
- Inventory tracking

### User Interface
- Material Design 3 components
- Custom Ubuntu font family
- Responsive layouts
- Smooth animations and transitions
- Loading states and error handling

## 🛠 Tech Stack

- **Framework**: Flutter 3.10.8+
- **State Management**: Flutter BLoC 9.1.1
- **Navigation**: Go Router 17.0.0
- **Networking**: Dio 5.9.0
- **Local Storage**: SQLite (sqflite 2.4.2)
- **Dependency Injection**: Get It 9.2.0
- **UI Components**: Material Design, Custom widgets
- **Authentication**: OTP with Pinput 6.0.1

## 📁 Project Structure

```
lib/
├── core/
│   ├── api_services/     # API layer
│   ├── bloc_observer/    # BLoC observer
│   ├── bloc_provider/    # BLoC providers
│   ├── di/              # Dependency injection
│   ├── ui/
│   │   ├── theme/       # App themes and colors
│   │   └── widgets/     # Common UI widgets
│   └── utils/           # Utility functions and constants
├── features/
│   ├── auth/            # Authentication feature
│   │   ├── data/
│   │   │   ├── models/  # Data models
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── repositories/
│   │   └── ui/
│   │       ├── bloc/    # BLoC implementation
│   │       └── screens/ # UI screens
│   └── home/            # Dashboard and product management
│       ├── data/
│       ├── domain/
│       └── ui/
│           ├── bloc/
│           ├── screens/
│           └── widgets/
└── main.dart
```

## 🚦 Getting Started

### Prerequisites
- Flutter SDK 3.10.8
- Dart SDK compatible with Flutter version
- Android Studio / VS Code with Flutter extensions
- Android SDK / Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd eshops
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Development Setup

1. **Environment Setup**
   - Ensure Flutter is properly configured
   - Set up your preferred IDE
   - Configure emulators or physical devices

2. **Code Style**
   - Follow Flutter/Dart conventions
   - Use `flutter analyze` for code analysis
   - Run `flutter test` for unit tests

## 🏗 Architecture

### Clean Architecture Pattern
The app follows clean architecture principles with clear separation of concerns:

- **Presentation Layer**: UI components, BLoC, screens
- **Domain Layer**: Business logic, entities, use cases
- **Data Layer**: Data sources, repositories, models

### BLoC Pattern
- State management using Flutter BLoC
- Reactive programming with streams
- Separation of business logic from UI

### Dependency Injection
- Service locator pattern with Get It
- Loose coupling between components
- Easy testing and maintenance

## 🎨 UI/UX Features

- **Custom Theme**: Consistent color scheme and typography
- **Responsive Design**: Adapts to different screen sizes
- **Animations**: Smooth transitions and micro-interactions
- **Loading States**: User-friendly loading indicators
- **Error Handling**: Graceful error messages and recovery

## 🔧 Configuration

### Environment Variables
Configure API endpoints and other settings in the appropriate configuration files.

### Database
- Local SQLite database for offline data
- Proper migration handling

## 📱 Platform Support

- ✅ Android
- ✅ iOS

## 📦 Build & Deployment

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

## 🐛 Issues & Support

If you encounter any issues or have questions:

1. Check the [Issues](../../issues) page
2. Create a new issue with detailed description
3. Include steps to reproduce the problem
4. Add screenshots if applicable

## 🔄 Version History

- **v1.0.0** - Initial release with core features
  - User authentication
  - Admin and Seller dashboards
  - Product management
  - Basic e-commerce functionality


**Built with ❤️ using Flutter**
