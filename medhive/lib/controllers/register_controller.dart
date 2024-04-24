import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/string_constants.dart';

import '../constants/authentication_response.dart';
import '../helpers/image_clarity_helper.dart';
import '../repositories/firebase_repository.dart';
import '../services/authentication_service.dart';
import '../widgets/mh_snackbar.dart';

class RegisterPageController extends AuthenticationService {
  final FirestoreRepository _firestoreRepository;

  RegisterPageController(
    this._firestoreRepository,
  );

  Future<AuthenticationResponseEnum> signUpUserWithGoogle(
      bool isCheckboxChecked, BuildContext context) async {
    bool isChecked = checkingCheckbox(isCheckboxChecked, context);
    if (isChecked == true) {
      final authMessage = await signInWithGoogle(context);
      if (authMessage == AuthenticationResponseEnum.authSuccess) {
        await _firestoreRepository.addPrivateUser("");
      }
      return authMessage;
    }
    return AuthenticationResponseEnum.uncheckedTermsAndConditions;
  }

  Future<AuthenticationResponseEnum> signUpUserWithEmailAndPassword(
      bool isCheckboxChecked,
      BuildContext context,
      String password,
      String email,
      String userName) async {
    bool isChecked = checkingCheckbox(isCheckboxChecked, context);
    if (isChecked == true) {
      final authResponse = await signUpWithEmailAndPassword(email, password);
      if (authResponse == AuthenticationResponseEnum.authSuccess) {
        await _firestoreRepository.addPrivateUser(userName);
      }
      return authResponse;
    }
    return AuthenticationResponseEnum.uncheckedTermsAndConditions;
  }

  String? processGoogleUserAvatar(String? photoUrl) {
    var url = photoUrl;
    if (url?.contains('lh3.googleusercontent') ?? false) {
      url = increaseImageQualityOfGoogleImage(url!);
    }

    return url;
  }

  bool checkingCheckbox(bool isCheckboxChecked, BuildContext context) {
    if (isCheckboxChecked == false) {
      showMhSnackbar(context, TERMS_AND_CONDITIONS_AGREEMENT);
      return false;
    }
    return true;
  }
}

final registerPageProvider = Provider<RegisterPageController>((ref) {
  final firestoreRepository = ref.read(firestoreRepositoryProvider);

  return RegisterPageController(
    firestoreRepository,
  );
});
