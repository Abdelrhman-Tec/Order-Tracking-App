# 📦 Order Tracking App

A modern, full-featured order tracking application built with Flutter, enabling real-time order monitoring, live location tracking, and seamless order management through an intuitive mobile interface.

<br>

## 🚀 Project Overview

Order Tracking App is a comprehensive mobile solution designed to streamline the order delivery process. It provides users with real-time tracking capabilities, allowing them to monitor their orders from placement to delivery. The app integrates Google Maps for live location tracking, Firebase for backend services, and implements clean architecture principles for maintainability and scalability.

Whether you're a customer tracking your delivery or a business managing orders, this app delivers a smooth, professional experience with multi-language support and robust state management.

<br>

## 🛠️ Tech Stack

### **Frontend & Framework**
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language

### **State Management & Architecture**
- **flutter_bloc** (^8.1.6) - Business Logic Component pattern for state management
- **Clean Architecture** - Separation of concerns with feature-based structure

### **Backend & Services**
- **Firebase Core** (^3.8.1) - Firebase initialization and configuration
- **Cloud Firestore** (^5.5.2) - NoSQL cloud database for real-time data sync
- **Firebase Auth** (^5.3.3) - Authentication and user management

### **Maps & Location**
- **Google Maps Flutter** (^2.9.0) - Interactive map integration
- **Geolocator** (^13.0.2) - GPS location services
- **Geocoding** (^3.0.0) - Address to coordinates conversion

### **UI & Design**
- **flutter_screenutil** (^5.9.3) - Responsive UI adaptation
- **flutter_svg** (^2.0.10+1) - SVG rendering support
- **cached_network_image** (^3.4.1) - Efficient image loading and caching

### **Utilities**
- **easy_localization** (^3.0.7) - Internationalization (i18n) support
- **go_router** (^14.6.2) - Declarative routing
- **dio** (^5.7.0) - HTTP client for API requests
- **get_it** (^8.0.2) - Dependency injection
- **dartz** (^0.10.1) - Functional programming utilities
- **intl** (^0.20.1) - Date formatting and internationalization
- **flutter_dotenv** (^5.2.1) - Environment variable management

<br>

## 🏗️ Architecture

The application follows **Clean Architecture** principles with a feature-based modular structure:

```
lib/
├── core/                          # Core functionalities
│   ├── api/                       # API clients and configurations
│   ├── routes/                    # Navigation and routing
│   ├── error/                     # Error handling
│   ├── utils/                     # Helper functions and utilities
│   └── widgets/                   # Reusable UI components
│
├── features/                      # Feature modules
│   ├── home/                      # Home screen feature
│   │   ├── data/                  # Data layer
│   │   │   ├── models/           # Data models
│   │   │   ├── data_sources/     # Remote/Local data sources
│   │   │   └── repos/            # Repository implementations
│   │   ├── domain/                # Business logic layer
│   │   │   ├── entities/         # Domain entities
│   │   │   ├── repos/            # Repository interfaces
│   │   │   └── use_cases/        # Business use cases
│   │   └── presentation/          # UI layer
│   │       ├── manager/          # BLoC/Cubit state management
│   │       ├── views/            # Screen widgets
│   │       └── widgets/          # Feature-specific widgets
│   │
│   ├── order_details/             # Order details feature
│   ├── tracking/                  # Live tracking feature
│   └── order_history/             # Order history feature
│
├── assets/                        # Static assets
│   ├── images/                    # Image files
│   └── translate/                 # Localization files
│
└── main.dart                      # Application entry point
```

### **Design Patterns**
- **BLoC Pattern** - Predictable state management
- **Repository Pattern** - Data abstraction layer
- **Dependency Injection** - Loose coupling via GetIt
- **Either Pattern** - Functional error handling with Dartz

<br>

## ✨ Features

### **Core Functionality**
- ✅ **Real-time Order Tracking** - Monitor delivery status in real-time
- 🗺️ **Live Location Updates** - Track delivery personnel on Google Maps
- 📍 **GPS Integration** - Accurate location services using Geolocator
- 🔥 **Firebase Integration** - Cloud-based data storage and sync
- 🔐 **User Authentication** - Secure login with Firebase Auth

### **User Experience**
- 🌍 **Multi-language Support** - Arabic and English localization
- 📱 **Responsive Design** - Adapts to different screen sizes
- 🎨 **Modern UI/UX** - Clean, intuitive interface
- 💾 **Offline Caching** - Cached network images for better performance
- 🔄 **State Management** - Efficient BLoC pattern implementation

### **Technical Features**
- 🏗️ **Clean Architecture** - Maintainable and scalable codebase
- 🔌 **API Integration** - RESTful API communication via Dio
- 🧩 **Modular Structure** - Feature-based organization
- 🛣️ **Declarative Routing** - Type-safe navigation with GoRouter
- 🔒 **Environment Variables** - Secure API key management

<br>

## 🧪 Testing

The project includes comprehensive testing support:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^6.0.0
```

### **Running Tests**
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/features/home/home_test.dart
```

<br>

## 📁 Folder Structure

```
order_tracking_app/
│
├── android/                       # Android-specific files
│   ├── app/
│   │   ├── src/main/
│   │   │   ├── AndroidManifest.xml
│   │   │   └── res/              # Android resources
│   │   └── google-services.json  # Firebase configuration
│   └── gradle/                    # Gradle build scripts
│
├── assets/
│   ├── images/                    # App images and icons
│   │   └── my_marker.png         # Custom map marker
│   └── translate/                 # i18n JSON files
│       ├── en.json               # English translations
│       └── ar.json               # Arabic translations
│
├── lib/
│   ├── core/
│   │   ├── api/                   # API configurations
│   │   ├── routes/
│   │   │   └── app_router.dart   # GoRouter configuration
│   │   ├── utils/                 # Helper utilities
│   │   └── widgets/               # Shared widgets
│   │
│   ├── features/
│   │   ├── home/
│   │   ├── order_details/
│   │   ├── tracking/
│   │   └── order_history/
│   │
│   ├── firebase_options.dart      # Firebase platform configuration
│   ├── order_tracking_app.dart    # Main app widget
│   └── main.dart                  # App entry point
│
├── macos/                         # macOS platform support
├── .env                           # Environment variables
├── pubspec.yaml                   # Dependencies configuration
└── README.md                      # Project documentation
```

<br>

## 🚀 How to Run the Project

### **Prerequisites**
- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Android Studio / VS Code with Flutter extensions
- Firebase project setup
- Google Maps API key

### **Installation Steps**

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/order_tracking_app.git
   cd order_tracking_app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Download `google-services.json` for Android
   - Place it in `android/app/`
   - Update `firebase_options.dart` with your configuration

4. **Set up Google Maps**
   - Get an API key from [Google Cloud Console](https://console.cloud.google.com/)
   - Add the key to `android/app/src/main/AndroidManifest.xml`:
     ```xml
     <meta-data
         android:name="com.google.android.geo.API_KEY"
         android:value="YOUR_API_KEY_HERE"/>
     ```

5. **Create .env file**
   ```bash
   # Create .env file in the root directory
   touch .env
   ```
   Add your environment variables:
   ```
   API_BASE_URL=your_api_url
   MAPS_API_KEY=your_maps_key
   ```

6. **Run the app**
   ```bash
   # For development
   flutter run

   # For release build
   flutter build apk --release
   ```

### **Platform-Specific Setup**

**Android:**
- Minimum SDK: 21 (Android 5.0)
- Target SDK: 34

**iOS/macOS:**
- Ensure Xcode is installed
- Update `Info.plist` with location permissions

<br>

## 🔮 Future Improvements

### **Planned Features**
- [ ] Push notifications for order status updates
- [ ] Payment gateway integration
- [ ] Order rating and review system
- [ ] Chat support between customer and delivery personnel
- [ ] Multiple address management
- [ ] Order scheduling feature
- [ ] Dark mode support
- [ ] Delivery route optimization
- [ ] Analytics dashboard for order insights
- [ ] Social media authentication (Google, Facebook)

### **Technical Enhancements**
- [ ] Unit and integration test coverage
- [ ] CI/CD pipeline setup
- [ ] Performance optimization
- [ ] Offline-first architecture
- [ ] GraphQL migration for better data fetching
- [ ] Custom map themes and styles

<br>

## 📸 Screenshots

> Add your app screenshots here to showcase the UI/UX

```
## Home Screen          ## Order Tracking       ## Order History
[Screenshot 1]         [Screenshot 2]          [Screenshot 3]

## Map View             ## Order Details        ## Settings
[Screenshot 4]         [Screenshot 5]          [Screenshot 6]
```

**How to add screenshots:**
1. Create a `screenshots/` folder in your repository
2. Add your images (recommended size: 1080x1920 for mobile)
3. Update README with image links:
   ```markdown
   ![Home Screen](screenshots/home.png)
   ```

<br>

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

Please ensure your code follows the existing architecture patterns and includes appropriate tests.

<br>

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

<br>

## 📞 Contact & Social Links

**Developer:** Abdelrahman Nada

[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/yourusername)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/yourprofile)
[![Twitter](https://img.shields.io/badge/Twitter-1DA1F2?style=for-the-badge&logo=twitter&logoColor=white)](https://twitter.com/yourhandle)
[![Email](https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:your.email@example.com)

<br>

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- Google Maps Platform for location services
- The open-source community for incredible packages

---

<div align="center">
  
**⭐ If you find this project helpful, please consider giving it a star!**

Made with ❤️ using Flutter

</div>