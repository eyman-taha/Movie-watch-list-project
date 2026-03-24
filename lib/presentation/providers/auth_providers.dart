import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'providers.dart';

class User {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;

  User({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
  });

  User copyWith({String? displayName, String? photoUrl}) {
    return User(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

class LocalAuthService {
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userNameKey = 'user_name';
  static const String _isLoggedInKey = 'is_logged_in';

  final SharedPreferences _prefs;

  LocalAuthService(this._prefs);

  User? get currentUser {
    final isLoggedIn = _prefs.getBool(_isLoggedInKey) ?? false;
    if (!isLoggedIn) return null;

    final id = _prefs.getString(_userIdKey);
    final email = _prefs.getString(_userEmailKey);

    if (id == null || email == null) return null;

    return User(
      id: id,
      email: email,
      displayName: _prefs.getString(_userNameKey),
    );
  }

  bool get isLoggedIn => _prefs.getBool(_isLoggedInKey) ?? false;

  Future<User> signIn(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty) {
      throw AuthException('Email and password are required');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setBool(_isLoggedInKey, true);

    return User(id: userId, email: email);
  }

  Future<User> signUp(String email, String password, String name) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (email.isEmpty || password.isEmpty || name.isEmpty) {
      throw AuthException('All fields are required');
    }

    if (!email.contains('@')) {
      throw AuthException('Invalid email address');
    }

    if (password.length < 6) {
      throw AuthException('Password must be at least 6 characters');
    }

    final userId = DateTime.now().millisecondsSinceEpoch.toString();

    await _prefs.setString(_userIdKey, userId);
    await _prefs.setString(_userEmailKey, email);
    await _prefs.setString(_userNameKey, name);
    await _prefs.setBool(_isLoggedInKey, true);

    return User(id: userId, email: email, displayName: name);
  }

  Future<void> signOut() async {
    await _prefs.remove(_userIdKey);
    await _prefs.remove(_userEmailKey);
    await _prefs.remove(_userNameKey);
    await _prefs.setBool(_isLoggedInKey, false);
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    if (displayName != null) {
      await _prefs.setString(_userNameKey, displayName);
    }
    if (photoUrl != null) {
      await _prefs.setString('user_photo', photoUrl);
    }
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

final authServiceProvider = Provider<LocalAuthService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return LocalAuthService(prefs);
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});

final authNotifierProvider = authStateProvider;

final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  final user = ref.watch(currentUserProvider);
  return user != null;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final LocalAuthService _authService;

  AuthNotifier(this._authService) : super(AuthState.initial()) {
    _checkAuthState();
  }

  void _checkAuthState() {
    final user = _authService.currentUser;
    if (user != null) {
      state = AuthState(user: user);
    }
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signIn(email, password);
      state = AuthState(user: user, isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signUp(email, password, name);
      state = AuthState(user: user, isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await _authService.signIn('google@gmail.com', 'google123');
      state = AuthState(user: user, isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _authService.signOut();
    state = AuthState.initial();
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    await _authService.updateProfile(
      displayName: displayName,
      photoUrl: photoUrl,
    );
    if (state.user != null) {
      final updatedUser = state.user!.copyWith(
        displayName: displayName,
        photoUrl: photoUrl,
      );
      state = state.copyWith(user: updatedUser);
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      if (email.isEmpty || !email.contains('@')) {
        throw AuthException('Invalid email address');
      }
      state = state.copyWith(isLoading: false);
      return true;
    } on AuthException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }
}

class AuthState {
  final bool isLoading;
  final User? user;
  final String? error;

  AuthState({this.isLoading = false, this.user, this.error});

  factory AuthState.initial() => AuthState();

  AuthState copyWith({bool? isLoading, User? user, String? error}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
    );
  }
}
