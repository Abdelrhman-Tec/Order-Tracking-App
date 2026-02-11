import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dart_either/dart_either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:order_tracking_app/core/error/auth_error_handler.dart';
import 'package:order_tracking_app/feature/auth/data/model/user_model.dart';

class AuthRepo {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<Either<String, String>> registerUser({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      log('Starting registration for: $email');

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return const Left('User is null');
      }

      User user = userCredential.user!;
      log('User created in Auth: ${user.uid}');

      await firestore.collection('users').doc(user.uid).set({
        "email": email,
        "uid": user.uid,
        "username": username,
        "createdAt": DateTime.now().toIso8601String(),
      });

      log('User saved to Firestore');
      return const Right('Account created successfully');
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} - ${e.message}');
      try {
        await auth.currentUser?.delete();
      } catch (_) {}
      return Left(AuthErrorHandler.message(e));
    } on FirebaseException catch (e) {
      log('FirebaseException: ${e.code} - ${e.message}');
      try {
        await auth.currentUser?.delete();
      } catch (_) {}

      if (e.code == 'permission-denied') {
        return const Left(
          'Permission denied. Please check Firestore security rules.',
        );
      }
      return Left('Failed to save user data: ${e.message}');
    } catch (exp, stackTrace) {
      log('Register error: $exp');
      log('StackTrace: $stackTrace');
      try {
        await auth.currentUser?.delete();
      } catch (_) {}
      return Left('Failed to create account: $exp');
    }
  }

  Future<Either<String, UserModel>> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      log('Attempting login for: $email');

      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        return const Left('User is null');
      }

      String userId = userCredential.user!.uid;
      log('User authenticated: $userId');

      DocumentSnapshot<Map<String, dynamic>> doc = await firestore
          .collection('users')
          .doc(userId)
          .get();

      if (!doc.exists) {
        log('User document not found');
        return const Left('User data not found');
      }

      if (doc.data() == null) {
        log('User data is null');
        return const Left('User data is empty');
      }

      Map<String, dynamic> userData = doc.data()!;
      log('User data retrieved: $userData');

      UserModel userModel = UserModel.fromJson(userData);
      log('UserModel created successfully: ${userModel.uid}');

      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException in login: ${e.code} - ${e.message}');
      return Left(AuthErrorHandler.message(e));
    } catch (exp, stackTrace) {
      log('Unexpected error in loginUser: $exp');
      log('StackTrace: $stackTrace');
      return Left('Login failed: $exp');
    }
  }

  Future<Either<String, UserModel>> updateUserProfile({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    try {
      log('Updating user profile: $uid');

      await firestore.collection('users').doc(uid).update(data);

      final updatedDoc = await firestore.collection('users').doc(uid).get();

      if (!updatedDoc.exists || updatedDoc.data() == null) {
        return const Left('Failed to retrieve updated profile');
      }

      final userModel = UserModel.fromJson(updatedDoc.data()!);
      log('Profile updated successfully');
      return Right(userModel);
    } on FirebaseException catch (e) {
      log('FirebaseException in updateUserProfile: ${e.code}');
      return Left('Failed to update profile: ${e.message}');
    } catch (e, stackTrace) {
      log('Error updating profile: $e');
      log('StackTrace: $stackTrace');
      return const Left('Failed to update profile');
    }
  }

  Future<Either<String, String>> deleteUser() async {
    try {
      User? user = auth.currentUser;
      if (user == null) {
        return const Left('No user logged in');
      }

      log('Deleting user: ${user.uid}');

      await user.delete();
      await firestore.collection('users').doc(user.uid).delete();

      log('User deleted successfully');
      return const Right('User deleted successfully');
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException in deleteUser: ${e.code}');
      return Left(AuthErrorHandler.message(e));
    } catch (e, stackTrace) {
      log('Error deleting user: $e');
      log('StackTrace: $stackTrace');
      return const Left('Failed to delete user');
    }
  }

  Future<Either<String, String>> logoutUser() async {
    try {
      log('Logging out user');
      await auth.signOut();
      log('Logout successful');
      return const Right('Logout successful');
    } catch (e, stackTrace) {
      log('Error during logout: $e');
      log('StackTrace: $stackTrace');
      return const Left('Failed to logout');
    }
  }

  Future<Either<String, UserModel>> getUserProfile() async {
    try {
      final user = auth.currentUser;
      if (user == null) {
        return const Left('No user logged in');
      }

      log('Getting user profile: ${user.uid}');

      final doc = await firestore.collection('users').doc(user.uid).get();

      if (!doc.exists) {
        return const Left('User not found');
      }

      if (doc.data() == null) {
        return const Left('User data is empty');
      }

      final userModel = UserModel.fromJson(doc.data()!);
      log('Profile retrieved successfully');
      return Right(userModel);
    } catch (e, stackTrace) {
      log('Error getting profile: $e');
      log('StackTrace: $stackTrace');
      return const Left('Failed to load profile');
    }
  }

  Future<bool> hasCurrentUser() async {
    return auth.currentUser != null;
  }
}
