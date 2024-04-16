import 'package:flutter/cupertino.dart';
import 'package:medhive/constants/string_constants.dart';

enum AuthenticationResponseEnum {
  userNotFound,
  wrongPassword,
  weakPassword,
  emailAlreadyInUse,
  accountAlreadyExistsWithDifferentCredential,
  invalidCredential,
  invalidEmail,
  authSuccess,
  uncheckedTermsAndConditions,
  emailSentSuccessfully,
  somethingWentWrong;

  String getMessage(BuildContext context) {
    switch (this) {
      case AuthenticationResponseEnum.userNotFound:
        return NO_USER_FOUND;
      case AuthenticationResponseEnum.wrongPassword:
        return WRONG_PASSWORD;
      case AuthenticationResponseEnum.weakPassword:
        return WEAK_PASSWORD;
      case AuthenticationResponseEnum.emailAlreadyInUse:
        return ACCOUNT_ALREADY_EXISTS;
      case AuthenticationResponseEnum
          .accountAlreadyExistsWithDifferentCredential:
        return ACCOUNT_ALREADY_EXISTS_WITH_DIFFERENT_CREDENTIALS;
      case AuthenticationResponseEnum.invalidCredential:
        return INVALID_CREDENTIAL;
      case AuthenticationResponseEnum.invalidEmail:
        return INVALID_EMAIL;
      case AuthenticationResponseEnum.somethingWentWrong:
        return AUTH_ERROR_MESSAGE;
      case AuthenticationResponseEnum.emailSentSuccessfully:
        return SUCCESSFUL_EMAIL_SENT;
      case AuthenticationResponseEnum.uncheckedTermsAndConditions:
        return TERMS_AND_CONDITIONS_AGREEMENT;
      case AuthenticationResponseEnum.authSuccess:
        return '';
    }
  }
}