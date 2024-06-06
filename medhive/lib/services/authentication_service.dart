import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medhive/constants/string_constants.dart';

import '../constants/authentication_response.dart';
import '../constants/firebase_auth_error_codes.dart';

enum AuthProviderEnum {
  password,
  google;

  String get providerId {
    switch (this) {
      case AuthProviderEnum.password:
        return 'password';
      case AuthProviderEnum.google:
        return 'google.com';
    }
  }
}

class AuthenticationService {
  static const String authSuccess = 'success';
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get authStateChange => _auth.authStateChanges();
  static String? get currentUserId => _auth.currentUser?.uid;
  static String? get currentUserName => _auth.currentUser?.displayName;
  static String? get currentUserEmail => _auth.currentUser?.email;
  static String? get currentUserImage => _auth.currentUser?.photoURL;
  static User? get currentUser => _auth.currentUser;

  static String? emailValidation(dynamic email, BuildContext context) {
    if (email == null ||
        email.isEmpty ||
        !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9!#$%&'*+-/=?^_`{|}~]+@([a-zA-Z0-9]|([a-zA-Z0-9]+[a-zA-Z0-9-]+[a-zA-Z0-9]))+\.[a-zA-Z]+")
            .hasMatch(email)) {
      return INVALID_EMAIL;
    }
    return null;
  }

  static String? passwordValidation(dynamic password, BuildContext context) {
    if (password == null ||
        password.isEmpty ||
        password.length < 8 ||
        !RegExp('^(?=.*?[0-9])').hasMatch(password)) {
      return INVALID_PASSWORD;
    }
    return null;
  }

  Future<AuthenticationResponseEnum> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthErrorCodes.userNotFound) {
        return AuthenticationResponseEnum.userNotFound;
      } else if (e.code == FirebaseAuthErrorCodes.wrongPassword) {
        return AuthenticationResponseEnum.wrongPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidCredential) {
        return AuthenticationResponseEnum.invalidCredential;
      } else if (e.code == FirebaseAuthErrorCodes.weakPassword) {
        return AuthenticationResponseEnum.weakPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidEmail) {
        return AuthenticationResponseEnum.invalidEmail;
      } else if (e.code == FirebaseAuthErrorCodes.emailAlreadyInUse) {
        return AuthenticationResponseEnum.emailAlreadyInUse;
      }
    } catch (e) {
      return AuthenticationResponseEnum.somethingWentWrong;
    }
    return AuthenticationResponseEnum.authSuccess;
  }

  Future<AuthenticationResponseEnum> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthErrorCodes.userNotFound) {
        return AuthenticationResponseEnum.userNotFound;
      } else if (e.code == FirebaseAuthErrorCodes.wrongPassword) {
        return AuthenticationResponseEnum.wrongPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidCredential) {
        return AuthenticationResponseEnum.invalidCredential;
      } else if (e.code == FirebaseAuthErrorCodes.weakPassword) {
        return AuthenticationResponseEnum.weakPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidEmail) {
        return AuthenticationResponseEnum.invalidEmail;
      } else if (e.code == FirebaseAuthErrorCodes.emailAlreadyInUse) {
        return AuthenticationResponseEnum.emailAlreadyInUse;
      }
    } catch (e) {
      return AuthenticationResponseEnum.somethingWentWrong;
    }
    return AuthenticationResponseEnum.authSuccess;
  }

  Future<AuthenticationResponseEnum> signInWithGoogle(
      BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return AuthenticationResponseEnum.somethingWentWrong;
    }
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthErrorCodes.userNotFound) {
        return AuthenticationResponseEnum.userNotFound;
      } else if (e.code == FirebaseAuthErrorCodes.wrongPassword) {
        return AuthenticationResponseEnum.wrongPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidCredential) {
        return AuthenticationResponseEnum.invalidCredential;
      } else if (e.code == FirebaseAuthErrorCodes.weakPassword) {
        return AuthenticationResponseEnum.weakPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidEmail) {
        return AuthenticationResponseEnum.invalidEmail;
      } else if (e.code == FirebaseAuthErrorCodes.emailAlreadyInUse) {
        return AuthenticationResponseEnum.emailAlreadyInUse;
      }
    } catch (e) {
      return AuthenticationResponseEnum.somethingWentWrong;
    }
    return AuthenticationResponseEnum.authSuccess;
  }

  Future<AuthenticationResponseEnum> resetPassword(
      String email, BuildContext context) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      if (e.code == FirebaseAuthErrorCodes.userNotFound) {
        return AuthenticationResponseEnum.userNotFound;
      } else if (e.code == FirebaseAuthErrorCodes.wrongPassword) {
        return AuthenticationResponseEnum.wrongPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidCredential) {
        return AuthenticationResponseEnum.invalidCredential;
      } else if (e.code == FirebaseAuthErrorCodes.weakPassword) {
        return AuthenticationResponseEnum.weakPassword;
      } else if (e.code == FirebaseAuthErrorCodes.invalidEmail) {
        return AuthenticationResponseEnum.invalidEmail;
      } else if (e.code == FirebaseAuthErrorCodes.emailAlreadyInUse) {
        return AuthenticationResponseEnum.emailAlreadyInUse;
      }
    } catch (e) {
      return AuthenticationResponseEnum.somethingWentWrong;
    }
    return AuthenticationResponseEnum.emailSentSuccessfully;
  }

  Future<void> signOut() async {
    await _auth.signOut();
    return;
  }

  Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    return;
  }
}
