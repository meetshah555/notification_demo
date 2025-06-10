# notification_demo

A Flutter application demonstrating Firebase push notifications implementation with cross-platform support for both Android and iOS, including proper permissions handling and notification channel configuration.

## 🚀 Features

- Firebase Cloud Messaging (FCM) integration
- Local notifications support
- Background and foreground notification handling
- Android 13+ notification permissions
- Proper notification channel configuration
- OTP verification screen demo

## ⚙️ Setup Requirements

### Firebase Configuration

This project uses **FlutterFire CLI** for Firebase configuration. You'll need to set up your own Firebase project and generate the required configuration files.

### Missing Configuration Files

This repository **does not include** the following Firebase configuration files (you need to generate these for your own project):

**Common:**
- `firebase.json`
- `lib/firebase_options.dart`

**Android:**
- `android/app/google-services.json`

**iOS:**
- `ios/Runner/GoogleService-Info.plist`
- `ios/Podfile.lock`

### Getting Started

1. **Install FlutterFire CLI:**
   ```bash
   dart pub global activate flutterfire_cli
   ```

2. **Configure Firebase for your project:**
   ```bash
   flutterfire configure
   ```
   This will:
   - Create a new Firebase project (or select existing one)
   - Generate `firebase_options.dart`
   - Download platform-specific configuration files
   - Update your `pubspec.yaml` with required dependencies

3. **Install dependencies:**
   ```bash
   flutter pub get
   ```

4. **Run the app:**
   ```bash
   flutter run
   ```

## 🔧 Key Dependencies

- `firebase_core` - Firebase core functionality
- `firebase_messaging` - FCM integration
- `flutter_local_notifications` - Local notifications
- `permission_handler` - Runtime permissions
- `device_info_plus` - Device information
- `get` - State management and navigation

## 📚 Resources

- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firebase Console](https://console.firebase.google.com/)
- [Flutter Notifications Guide](https://docs.flutter.dev/development/platform-integration/platform-channels)

## 🤝 Contributing

Feel free to contribute to this project by submitting issues or pull requests.

## 📄 License

This project is for demonstration purposes.
