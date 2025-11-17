import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../models/user_model.dart';
import '../core/constants/app_constants.dart';
import '../utils/logger.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Get current user ID
  String? get currentUserId => currentUser?.uid;

  // Auth state changes stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign in with email and password
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Signing in with email: $email');
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login
      await _updateLastLogin(userCredential.user!.uid);

      AppLogger.info('Sign in successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign in failed', e);
      throw _handleAuthException(e);
    }
  }

  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
    try {
      AppLogger.info('Signing in with Google');
      
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        throw Exception('Google sign in aborted');
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      final userCredential = await _auth.signInWithCredential(credential);

      // Check if user exists in Firestore, if not create profile
      final userDoc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        // Create new user profile
        await _createUserProfile(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email!,
          role: UserRole.consultant, // Default role
        );
      } else {
        // Update last login
        await _updateLastLogin(userCredential.user!.uid);
      }

      AppLogger.info('Google sign in successful');
      return userCredential;
    } catch (e) {
      AppLogger.error('Google sign in failed', e);
      rethrow;
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      AppLogger.info('Signing up with email: $email');
      
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Create user profile in Firestore
      await _createUserProfile(
        uid: userCredential.user!.uid,
        email: email,
        role: role,
      );

      AppLogger.info('Sign up successful');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Sign up failed', e);
      throw _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      AppLogger.info('Signing out');
      await _googleSignIn.signOut();
      await _auth.signOut();
      AppLogger.info('Sign out successful');
    } catch (e) {
      AppLogger.error('Sign out failed', e);
      rethrow;
    }
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      await _auth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Password reset failed', e);
      throw _handleAuthException(e);
    }
  }

  // Change password
  Future<void> changePassword(String newPassword) async {
    try {
      AppLogger.info('Changing password');
      await currentUser?.updatePassword(newPassword);
      AppLogger.info('Password changed successfully');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Password change failed', e);
      throw _handleAuthException(e);
    }
  }

  // Get user data from Firestore
  Future<UserModel?> getUserData(String uid) async {
    try {
      final doc = await _firestore
          .collection(FirebaseCollections.users)
          .doc(uid)
          .get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromFirestore(doc);
    } catch (e) {
      AppLogger.error('Failed to get user data', e);
      rethrow;
    }
  }

  // Get current user data
  Future<UserModel?> getCurrentUserData() async {
    if (currentUserId == null) return null;
    return getUserData(currentUserId!);
  }

  // Update user data
  Future<void> updateUserData(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore
          .collection(FirebaseCollections.users)
          .doc(uid)
          .update(data);
      AppLogger.info('User data updated');
    } catch (e) {
      AppLogger.error('Failed to update user data', e);
      rethrow;
    }
  }

  // Create user profile in Firestore
  Future<void> _createUserProfile({
    required String uid,
    required String email,
    required UserRole role,
  }) async {
    final user = UserModel(
      id: uid,
      email: email,
      role: role,
      isActive: true,
      createdAt: DateTime.now(),
      lastLogin: DateTime.now(),
    );

    await _firestore
        .collection(FirebaseCollections.users)
        .doc(uid)
        .set(user.toJson());

    AppLogger.info('User profile created for: $email');
  }

  // Update last login timestamp
  Future<void> _updateLastLogin(String uid) async {
    await _firestore
        .collection(FirebaseCollections.users)
        .doc(uid)
        .update({'lastLogin': FieldValue.serverTimestamp()});
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return ErrorMessages.userNotFound;
      case 'wrong-password':
        return ErrorMessages.wrongPassword;
      case 'email-already-in-use':
        return ErrorMessages.emailAlreadyInUse;
      case 'weak-password':
        return ErrorMessages.weakPassword;
      case 'invalid-email':
        return 'Email invalide';
      case 'user-disabled':
        return 'Compte utilisateur désactivé';
      case 'too-many-requests':
        return 'Trop de tentatives. Veuillez réessayer plus tard.';
      default:
        return ErrorMessages.authError;
    }
  }

  // Delete account
  Future<void> deleteAccount() async {
    try {
      final uid = currentUserId;
      if (uid == null) throw Exception('No user signed in');

      AppLogger.info('Deleting account: $uid');

      // Delete user data from Firestore
      await _firestore.collection(FirebaseCollections.users).doc(uid).delete();

      // Delete Firebase Auth account
      await currentUser?.delete();

      AppLogger.info('Account deleted successfully');
    } catch (e) {
      AppLogger.error('Failed to delete account', e);
      rethrow;
    }
  }
}
