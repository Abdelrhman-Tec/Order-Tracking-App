import 'package:firebase_auth/firebase_auth.dart';

class AuthErrorHandler {
  AuthErrorHandler._();

  static String message(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'This email is already in use';

      case 'weak-password':
        return 'Password is too weak';

      case 'invalid-email':
        return 'Invalid email address';

      case 'user-disabled':
        return 'This user has been disabled';

      case 'operation-not-allowed':
        return 'Operation not allowed';

      case 'too-many-requests':
        return 'Too many requests, try again later';

      case 'network-request-failed':
        return 'No internet connection';

      case 'internal-error':
        return 'Internal error, please try again';

      default:
        return 'Failed to create the account';
    }
  }
}
