import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/auth_service.dart';

class TaskFlowAuthProvider extends ChangeNotifier {
  TaskFlowAuthProvider(this._authService);

  final AuthService _authService;

  bool _isBusy = false;
  String? _message;

  bool get isBusy => _isBusy;
  String? get message => _message;
  User? get user => _authService.currentUser;
  Stream<User?> get authChanges => _authService.authStateChanges();

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    return _guardedAuthCall(() {
      return _authService.createAccount(
        name: name,
        email: email,
        password: password,
      );
    });
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    return _guardedAuthCall(() {
      return _authService.signIn(email: email, password: password);
    });
  }

  Future<bool> resetPassword(String email) async {
    return _guardedAuthCall(() => _authService.sendPasswordReset(email));
  }

  Future<void> logout() => _authService.signOut();

  Future<bool> _guardedAuthCall(Future<void> Function() action) async {
    _setBusy(true);
    try {
      await action();
      _message = null;
      return true;
    } on FirebaseAuthException catch (error) {
      _message = _friendlyAuthMessage(error);
      return false;
    } catch (_) {
      _message = 'Something went wrong. Please try again.';
      return false;
    } finally {
      _setBusy(false);
    }
  }

  String _friendlyAuthMessage(FirebaseAuthException error) {
    switch (error.code) {
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is incorrect.';
      case 'email-already-in-use':
        return 'This email is already registered.';
      case 'weak-password':
        return 'Use a stronger password with at least 6 characters.';
      case 'configuration-not-found':
      case 'CONFIGURATION_NOT_FOUND':
        return 'Firebase Authentication is not configured for this project. Enable Email/Password sign-in in Firebase Console.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is disabled. Enable it in Firebase Authentication.';
      default:
        return error.message ?? 'Authentication failed.';
    }
  }

  void _setBusy(bool value) {
    _isBusy = value;
    notifyListeners();
  }
}
