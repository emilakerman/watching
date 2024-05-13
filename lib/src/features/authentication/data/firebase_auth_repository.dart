// This layer is responsible for interacting with the external
// data source (Firebase).
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:logger/web.dart';

import '../../../src.dart';

class FirebaseAuthRepository {
  final _auth = FirebaseAuth.instance;

  User? getUser() => _auth.currentUser;

  Future<void> createUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Logger().d('User ${getUser()?.email} created!');
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Error!';
      if (!context.mounted) return;
      if (error.message!.contains('email-already-in-use')) {
        errorMessage = 'emailAlreadyInUseErrorMessage';
      } else if (error.message!.contains('invalid-email')) {
        errorMessage = 'invalidEmailErrorMessage';
      } else if (error.message!.contains('operation-not-allowed')) {
        errorMessage = 'operationNotAllowedErrorMessage';
      } else if (error.message!.contains('weak-password')) {
        errorMessage = 'weakPasswordErrorMessage';
      }
      showSnackbar(
        context: context,
        message: error.message ?? errorMessage,
      );
    }
  }

  Future<void> signInUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Logger().d('User ${getUser()?.email} signed in!');
    } on FirebaseAuthException catch (error) {
      var errorMessage = 'Error!';
      if (!context.mounted) return;
      if (error.message!.contains('invalid-email')) {
        errorMessage = 'invalidEmailErrorMessage';
      } else if (error.message!.contains('invalid-credential')) {
        errorMessage = 'wrongPasswordErrorMessage';
      } else if (error.message!.contains('user-disabled')) {
        errorMessage = 'userDisabledErrorMessage';
      } else if (error.message!.contains('user-not-found')) {
        errorMessage = 'userNotFoundErrorMessage';
      } else if (error.message!.contains('too-many-requests')) {
        errorMessage = 'tooManyAttemptsErrorMessage';
      }
      showSnackbar(
        context: context,
        message: error.message ?? errorMessage,
      );
    }
  }

  Future<void> signOut() async => _auth.signOut();

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  bool isAuthenticated() => _auth.currentUser != null;
}
