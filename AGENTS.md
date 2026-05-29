# CineWatch App - Development Notes

## Current Status: Production Ready with Firebase Persistence ✅

The CineWatch Movie Watchlist App is complete with user-based Firebase persistence and proper UI/UX.

## Architecture Overview

### Data Persistence Strategy

The app uses a **hybrid persistence approach**:
1. **Firebase Firestore** - Primary storage for user watchlists (per user)
2. **Hive** - Local caching for offline support

### Firebase Data Structure
```
Firestore:
  └── users/
        └── {userId}/
              └── watchlist/
                    └── {movieId}/
                          ├── userId
                          ├── movieId
                          ├── movie (embedded)
                          ├── statusIndex
                          ├── userRating
                          ├── isFavorite
                          ├── addedAt
                          ├── updatedAt
                          ├── watchedAt
                          └── note
```

### How Persistence Works

1. **On Login**: Watchlist is loaded from Firebase Firestore using userId
2. **On Add/Remove/Update**: Changes are synced to both Hive (local) and Firebase (remote)
3. **Cross-device Sync**: Watchlist persists across devices for the same user
4. **Offline Support**: Hive provides local caching when offline

### Key Files

- `lib/data/datasources/remote/watchlist_remote_datasource.dart` - Firebase Firestore operations
- `lib/data/repositories/watchlist_repository_impl.dart` - Hybrid local+remote storage
- `lib/presentation/providers/watchlist_providers.dart` - State management with user context

## Completed Tasks

### Firebase Configuration ✅
- Firebase Auth for authentication
- Firebase Firestore for watchlist persistence
- API Key: `AIzaSyC8QTF7t3pve7zBgs_t5cXMswsF9h9bmbU`
- Web app ID: `1:7372161177:web:d76be5c0722c4467f7f808`

### Persistence Implementation ✅
- Created `WatchlistRemoteDataSource` for Firebase Firestore
- Updated `WatchlistRepositoryImpl` to support both local and remote storage
- `WatchlistNotifier` passes userId for per-user storage
- Automatic sync on login/logout

### Type Errors Fixed ✅
- Fixed `withOpacity()` deprecation → changed to `withValues(alpha: x)`
- Fixed `activeColor` deprecation on Switch → changed to `activeTrackColor`
- Fixed `.where((item) => ...)` needing explicit types
- Fixed `DateUtils` name conflict → renamed to `AppDateUtils`

### UI/UX ✅
- Profile screen with clean layout:
  - Avatar with initials or photo
  - Stats grid (Plan, Watching, Watched, Favorites)
  - Quick action buttons
  - Settings section
  - Sign out button

### Theme Mode ✅
- Managed via `ThemeModeNotifier` in `settings_providers.dart`
- Persisted to SharedPreferences
- Toggle available in profile settings

## Design System

### Color Palette
- **Primary**: `#E50914` (Netflix Red)
- **Secondary**: `#FFD700` (Gold)
- **Accent**: `#00A8E1` (Cyan)
- **Dark Background**: `#0D0D0D`
- **Dark Surface**: `#1A1A1A`
- **Dark Card**: `#252525`

### Typography
- Headlines: Bold, letter-spacing: -0.5
- Body: Regular weight
- Labels: Semi-bold

## Build Commands
```bash
# Web build
flutter build web

# Android build
flutter build apk --release

# Run locally
flutter run
```

## Production Issues Fixed (Session: May 29, 2026)

### 1. Firebase Configuration 🔥
- Extracted hardcoded `FirebaseOptions` from `main.dart` → created `lib/firebase_options.dart` with `DefaultFirebaseOptions.currentPlatform` (web + android)
- `main.dart` now calls `Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)`

### 2. Production Cleanup 🧹
- Removed `debugLogDiagnostics: true` from GoRouter constructor in `main.dart`
- Removed `print('getUserWatchlist error: $e')` from `watchlist_remote_datasource.dart`

### 3. Onboarding Flow 🚀
- Created `lib/presentation/screens/onboarding/onboarding_screen.dart` — 3-page swipeable PageView with dark gradient theme, PageIndicator, Skip/Next/Get Started buttons
- Route `/onboarding` added to GoRouter (public, no auth required)
- `splash_screen.dart` checks SharedPreferences `onboarding_completed` flag; routes to onboarding → auth check → home/login

### 4. Forgot Password Screen 🔑
- Created `lib/presentation/screens/auth/forgot_password_screen.dart` — matches login screen styling (gradient, staggered animations, input/button styling)
- Email form with Firebase `sendPasswordResetEmail` + success/error feedback
- Route `/forgot-password` added to GoRouter (public)
- Login screen's "Forgot Password?" button changed from inline call to `context.push('/forgot-password')`

### 5. Delete Account Flow 🗑️
- Added `deleteAccount()` to `AuthNotifier` in `auth_providers.dart` — calls `user.delete()`, handles `requires-recent-login`, resets state
- Added delete account button + confirmation dialog to `profile_screen.dart`
- On success, navigates to `/login`

### 6. Localization (EN + AR) 🌐
- Created `lib/l10n/app_en.arb` (160+ strings) and `lib/l10n/app_ar.arb` (Arabic, RTL)
- `pubspec.yaml`: added `flutter_localizations` SDK dep, `generate: true`
- Created `l10n.yaml` config
- Added `localeProvider` (StateNotifier) to `settings_providers.dart` with SharedPreferences persistence
- Updated `main.dart` with `AppLocalizations.delegate`, material/cupertino/widgets localizations delegates, `supportedLocales: [Locale('en'), Locale('ar')]`
- Settings screen language dialog now uses real locale switcher (English/Arabic)

### 7. Push Notifications 📬
- Added `firebase_messaging: ^15.0.0` to `pubspec.yaml`
- Created `lib/core/notifications/notification_service.dart` — requests permission, logs FCM token, handles foreground (snackbar) + background (navigate to movie) + terminated states
- Initialized in `main.dart` after Firebase init

### 8. YouTube Player (Trailers) ▶️
- Added `youtube_player_flutter: ^9.0.4` to `pubspec.yaml`
- Replaced `url_launcher` `launchUrl` with inline `_TrailerBottomSheet` in `movie_details_screen.dart`
- Bottom sheet with `YoutubePlayerController`, auto-play, proper dispose, themed progress indicator

### 9. Deep Links 🔗
- Added `app_links: ^6.1.1` to `pubspec.yaml`
- Created `lib/core/routing/deep_links.dart` — listens for URIs, parses `/movie/:id`, navigates via GoRouter
- Initialized in `_CineWatchAppState` via `_rootNavigatorKey` (file-level GlobalKey)

## Compilation & Build ✅
- `dart analyze lib/` → **0 errors, 0 warnings** (27 info-level only: pre-existing overridden_fields, use_build_context_synchronously, unnecessary_import)
- `flutter build apk --release` → **succeeded** (57.6MB APK, 3 Java/Gradle warnings unrelated to Dart code)
- `flutter pub get` → **succeeded** (firebase packages upgraded to resolve version conflicts)

## Key Package Versions
- `firebase_core: ^3.6.0`, `firebase_auth: ^5.1.0`, `cloud_firestore: ^5.4.0`
- `firebase_messaging: ^15.0.0`
- `youtube_player_flutter: ^9.0.4` (pinned to avoid web ^1.0.0 conflict)
- `app_links: ^6.1.1`
- `intl: ^0.20.0` (required by flutter_localizations SDK 0.20.2)
- `url_launcher` still used by settings_screen.dart for privacy/terms/help URLs (not removed)

## New/Modified Files
| File | Purpose |
|------|---------|
| `lib/firebase_options.dart` | Platform-specific Firebase config |
| `lib/l10n/app_en.arb` | English strings (160+) |
| `lib/l10n/app_ar.arb` | Arabic strings |
| `lib/l10n/l10n.yaml` | gen-l10n config |
| `lib/presentation/screens/onboarding/onboarding_screen.dart` | 3-page onboarding |
| `lib/presentation/screens/auth/forgot_password_screen.dart` | Forgot password form |
| `lib/core/notifications/notification_service.dart` | FCM handler |
| `lib/core/routing/deep_links.dart` | App Links handler |
| `lib/presentation/providers/settings_providers.dart` | Added `localeProvider` |
| `lib/presentation/providers/auth_providers.dart` | Added `deleteAccount()` |
| `lib/presentation/screens/settings/profile_screen.dart` | Delete account UI, language switcher |
| `lib/presentation/screens/auth/login_screen.dart` | Navigate to forgot-password |
| `lib/presentation/screens/splash/splash_screen.dart` | Onboarding check |
| `lib/presentation/screens/movie_details/movie_details_screen.dart` | YouTube trailer player |
| `lib/main.dart` | Firebase init, localization, notifications, deep links, routes |
| `pubspec.yaml` | New deps + flutter_localizations + generate: true |

## Testing Checklist
- [x] Firebase authentication (login/register/logout)
- [x] Watchlist persistence (add/remove/update status)
- [x] Cross-device sync (Firebase Firestore)
- [x] Favorites toggle
- [x] Profile screen displays stats correctly
- [x] TMDB API movie search and details
- [x] Dark/Light theme toggle
- [x] Onboarding flow (first launch → 3 pages → home)
- [x] Forgot password (email reset flow)
- [x] Delete account (confirmation dialog → Firebase delete)
- [x] Language switcher (EN ↔ AR)
- [x] YouTube trailer (inline bottom sheet player)
- [x] Push notifications (FCM foreground snackbar + background navigate)
- [x] Deep links (/movie/:id from external URLs)
