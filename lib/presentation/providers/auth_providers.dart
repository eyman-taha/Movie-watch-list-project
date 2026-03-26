import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthNotifier(auth);
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
  final FirebaseAuth _auth;

  AuthNotifier(this._auth) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((firebaseUser) {
      if (firebaseUser != null) {
        state = AuthState(
          user: User(
            id: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            displayName: firebaseUser.displayName,
            photoUrl: firebaseUser.photoURL,
          ),
        );
      } else {
        state = AuthState.initial();
      }
    });
  }

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        state = AuthState(
          user: User(
            id: credential.user!.uid,
            email: credential.user!.email ?? '',
            displayName: credential.user!.displayName,
            photoUrl: credential.user!.photoURL,
          ),
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      state = state.copyWith(isLoading: false, error: message);
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
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user != null) {
        await credential.user!.updateDisplayName(name);
        state = AuthState(
          user: User(
            id: credential.user!.uid,
            email: credential.user!.email ?? '',
            displayName: name,
            photoUrl: credential.user!.photoURL,
          ),
          isLoading: false,
        );
        return true;
      }
      state = state.copyWith(isLoading: false);
      return false;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'weak-password':
          message = 'Password should be at least 6 characters';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      state = state.copyWith(isLoading: false, error: message);
      return false;
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    state = AuthState.initial();
  }

  Future<void> updateProfile({String? displayName, String? photoUrl}) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        if (displayName != null) {
          await user.updateDisplayName(displayName);
        }
        if (photoUrl != null) {
          await user.updatePhotoURL(photoUrl);
        }
        state = state.copyWith(
          user: state.user?.copyWith(
            displayName: displayName,
            photoUrl: photoUrl,
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  Future<bool> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await _auth.sendPasswordResetEmail(email: email);
      state = state.copyWith(isLoading: false);
      return true;
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      state = state.copyWith(isLoading: false, error: message);
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
