import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/authentication_response.dart';
import '../repositories/firebase_repository.dart';
import '../services/authentication_service.dart';

class LogInPageController extends AuthenticationService {
  final FirestoreRepository firestoreRepository;
  LogInPageController({required this.firestoreRepository});

  Future<AuthenticationResponseEnum> logInUserWithGoogle(
      BuildContext context) async {
    final authMessage = await signInWithGoogle(context);
    if (authMessage == AuthenticationResponseEnum.authSuccess) {
      await firestoreRepository.addPrivateUser("");
    }
    return authMessage;
  }

  Future<AuthenticationResponseEnum> logInUserWithEmailAndPassword(
      String email, String password) async {
    AuthenticationResponseEnum authResponse =
    await signInWithEmailAndPassword(email, password);
    return authResponse;
  }
}

final logInPageProvider = Provider<LogInPageController>((ref) {
  final firestoreRepository = ref.read(firestoreRepositoryProvider);
  return LogInPageController(
    firestoreRepository: firestoreRepository,
  );
});
