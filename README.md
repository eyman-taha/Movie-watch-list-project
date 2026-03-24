# CineWatch

A feature-rich movie discovery and watchlist management app built with Flutter.

![Flutter](https://img.shields.io/badge/Flutter-3.41.4-blue)
![Dart](https://img.shields.io/badge/Dart-3.11.1-blue)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-green)

## Features

### Authentication
- **Email/Password Authentication**: Register and login with email
- **Google Sign-In**: Quick and easy authentication with Google
- **Password Reset**: Reset password via email
- **Protected Routes**: Only authenticated users can access watchlist

### Movie Discovery
- **Trending Movies**: Stay updated with the most popular movies of the week
- **Popular Movies**: Browse popular movies across all time
- **Top Rated**: Discover the highest-rated movies
- **Now Playing**: See what's currently in theaters
- **Upcoming Releases**: Get ahead with upcoming movie releases

### Watchlist System
- **3 Status Categories**:
  - Plan to Watch
  - Still Watching
  - Watched
- **Favorites**: Mark movies as favorites
- **Personal Ratings**: Rate movies on your own scale
- **User-Specific**: Each user's watchlist is personal and secure
- **Offline Support**: Data persists locally

### Search & Discovery
- Real-time movie search with debounce
- Filter by genre
- Search history tracking

### User Profile
- View and edit profile information
- View watchlist statistics
- Change password
- Sign out

### User Experience
- Dark mode as default theme
- Smooth animations and transitions
- Hero animations for movie posters
- Loading skeletons for better UX
- Pull-to-refresh functionality
- Responsive design for mobile, tablet, and web

## Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/                    # Core utilities, theme, constants
│   ├── constants/           # App constants, API constants
│   ├── errors/              # Error handling
│   ├── network/             # Network client
│   ├── theme/               # App theme
│   └── utils/               # Utility functions
├── data/                    # Data layer
│   ├── datasources/         # Local and remote data sources
│   │   ├── auth/           # Authentication service
│   │   ├── local/           # Hive local storage
│   │   └── remote/         # API calls
│   ├── models/              # Data models
│   └── repositories/        # Repository implementations
├── domain/                  # Domain layer
│   ├── entities/            # Business entities
│   └── repositories/        # Repository interfaces
└── presentation/            # Presentation layer
    ├── providers/          # Riverpod providers
    │   ├── auth_providers.dart    # Auth state management
    │   ├── movie_providers.dart   # Movie data providers
    │   ├── watchlist_providers.dart # Watchlist management
    │   └── settings_providers.dart  # App settings
    ├── screens/            # App screens
    │   ├── auth/           # Login, Register
    │   ├── home/           # Home screen
    │   ├── movie_details/ # Movie details
    │   ├── search/         # Search screen
    │   ├── settings/       # Settings, Profile
    │   ├── splash/        # Splash screen
    │   └── watchlist/      # Watchlist screen
    └── widgets/            # Reusable widgets
```

## Tech Stack

- **Framework**: Flutter 3.41.4
- **Language**: Dart 3.11.1
- **State Management**: Riverpod
- **HTTP Client**: Dio
- **Local Storage**: Hive
- **Navigation**: GoRouter
- **Image Caching**: cached_network_image
- **Animations**: flutter_staggered_animations
- **Authentication**: Firebase Auth

## Setup Instructions

### Prerequisites

1. **Flutter SDK** (3.x or later)
   - Install from [flutter.dev](https://flutter.dev/docs/get-started/install)

2. **TMDB API Key**
   - Get your free API key from [The Movie Database](https://www.themoviedb.org/settings/api)

3. **Firebase Project**
   - Create a project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication (Email/Password and Google Sign-In)
   - Download configuration files

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd cinewatch
   ```

2. **Add your TMDB API Key**
   
   Open `lib/core/constants/api_constants.dart` and replace the API key:
   ```dart
   static const String apiKey = 'YOUR_TMDB_API_KEY';
   ```

3. **Configure Firebase**
   
   a. Download your Firebase configuration files:
      - For Android: `google-services.json` → place in `android/app/`
      - For iOS: `GoogleService-Info.plist` → place in `ios/Runner/`
   
   b. Update `android/app/build.gradle.kts` with your package name if needed

4. **Install dependencies**
   ```bash
   flutter pub get
   ```

5. **Generate Hive adapters** (if needed)
   ```bash
   flutter pub run build_runner build
   ```

6. **Run the app**
   ```bash
   # For debug mode
   flutter run
   
   # For release mode
   flutter run --release
   ```

### Building for Production

#### Android
```bash
flutter build apk --release
# APK will be at: build/app/outputs/flutter-apk/app-release.apk
```

#### iOS
```bash
flutter build ios --release
# IPA will be at: build/ios/iphoneos/Runner.app
```

#### Web
```bash
flutter build web
# Build will be at: build/web/
```

## Project Structure

### Screens
- **Splash Screen**: App initialization with animated logo
- **Login Screen**: Email/password and Google sign-in
- **Register Screen**: New user registration
- **Home Screen**: Movie discovery with trending carousel and categorized lists
- **Search Screen**: Movie search with genre filtering
- **Watchlist Screen**: Personal movie tracking with 3 status categories
- **Movie Details Screen**: Full movie information with cast and similar movies
- **Profile Screen**: User profile with statistics and settings

### Authentication Flow
```
App Start
    ↓
Splash Screen (Check auth state)
    ↓
┌─────────────────────────────────┐
│  Authenticated?                  │
├───────────────┬─────────────────┤
│     YES       │      NO         │
│       ↓       │       ↓         │
│  Main Shell  │   Login Screen  │
│   (Home)     │         ↓       │
│       ↓      │    Register/     │
│  [Tab Nav]   │    Login/Google │
│  - Home      │         ↓        │
│  - Search    │   Authenticated? │
│  - Watchlist │         ↓        │
│  - Profile   │     Main Shell   │
└───────────────┴─────────────────┘
```

## Watchlist Categories

| Category | Description | Icon |
|----------|-------------|------|
| Plan to Watch | Movies you want to watch | Schedule |
| Still Watching | Movies you're currently watching | Play Arrow |
| Watched | Movies you've completed | Check |

## Configuration

### TMDB API
The app uses The Movie Database (TMDB) API. You'll need to:
1. Create an account at [TMDB](https://www.themoviedb.org/)
2. Request an API key from your account settings
3. Add the API key to `lib/core/constants/api_constants.dart`

### Firebase Setup
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project
3. Enable Authentication:
   - Email/Password provider
   - Google provider (optional)
4. For Android: Add package name `com.cinewatch.cinewatch`
5. Download and add `google-services.json`

### App Theming
- Dark mode is enabled by default
- Light mode can be toggled in Profile
- Theme customization available in `lib/core/theme/app_theme.dart`

## Dependencies

```yaml
dependencies:
  flutter_riverpod: ^2.5.1    # State management
  dio: ^5.4.0                  # HTTP client
  hive_flutter: ^1.1.0        # Local storage
  go_router: ^14.0.0          # Navigation
  cached_network_image: ^3.3.1 # Image caching
  flutter_staggered_animations: ^1.1.1  # Animations
  shimmer: ^3.0.0              # Loading effects
  url_launcher: ^6.2.4         # External links
  share_plus: ^7.2.2           # Share functionality
  firebase_core: ^2.27.0       # Firebase
  firebase_auth: ^4.18.0      # Firebase Auth
  google_sign_in: ^6.2.1      # Google Sign-In
  connectivity_plus: ^6.0.3    # Network status
  shared_preferences: ^2.2.2  # Key-value storage
```

## Troubleshooting

### Common Issues

1. **API Key Error**
   - Ensure you've added a valid TMDB API key
   - Check that the key has proper permissions

2. **Firebase Auth Not Working**
   - Verify google-services.json is in android/app/
   - Check Firebase Console authentication is enabled
   - Ensure package name matches

3. **Build Errors**
   - Run `flutter pub get` to ensure dependencies are installed
   - Try `flutter clean` followed by `flutter pub get`

4. **Hive Initialization Errors**
   - Run `flutter pub run build_runner build` to regenerate adapters
   - Clear app data if database is corrupted

## Security Notes

- User watchlist data is associated with their Firebase UID
- API keys are stored client-side (for demo purposes)
- In production, consider using a backend server for sensitive operations

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

This project is licensed under the MIT License.

## Acknowledgments

- [The Movie Database (TMDB)](https://www.themoviedb.org/) for providing the API
- [Firebase](https://firebase.google.com/) for authentication
- Flutter team for the amazing framework
- All open-source library contributors

---

**Note**: This app is for educational and personal use. Please respect TMDB's terms of service when using the API.
