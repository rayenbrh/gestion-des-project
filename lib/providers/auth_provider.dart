import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../utils/logger.dart';

// Auth service provider
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Firebase auth state provider
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Current user data provider
final currentUserDataProvider = StreamProvider<UserModel?>((ref) async* {
  final authState = ref.watch(authStateProvider);
  
  await for (final user in authState.stream) {
    if (user == null) {
      yield null;
    } else {
      final authService = ref.read(authServiceProvider);
      final userData = await authService.getUserData(user.uid);
      yield userData;
    }
  }
});

// Auth controller
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.data(null));

  // Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    });
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.signInWithGoogle();
    });
  }

  // Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.signUpWithEmailAndPassword(
        email: email,
        password: password,
        role: role,
      );
    });
  }

  // Sign out
  Future<void> signOut() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.signOut();
    });
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.resetPassword(email);
    });
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _authService.changePassword(newPassword);
    });
  }
}

// Auth controller provider
final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});

// Check if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.value != null;
});

// Check user role
final userRoleProvider = Provider<UserRole?>((ref) {
  final userData = ref.watch(currentUserDataProvider);
  return userData.value?.role;
});

// Check if user is admin
final isAdminProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.admin;
});

// Check if user is chef projet
final isChefProjetProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.chefProjet;
});

// Check if user is consultant
final isConsultantProvider = Provider<bool>((ref) {
  final role = ref.watch(userRoleProvider);
  return role == UserRole.consultant;
});
