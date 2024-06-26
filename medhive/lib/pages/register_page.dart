import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/string_constants.dart';
import 'package:medhive/helpers/useful_information_helper.dart';
import 'package:medhive/pages/initial_page_decider.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/services/authentication_service.dart';

import '../constants/authentication_response.dart';
import '../constants/mh_button_style.dart';
import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../controllers/register_controller.dart';
import '../controllers/register_path_provider.dart';
import '../helpers/cloud_firestore_helper.dart';
import '../helpers/screen_size_helper.dart';
import '../widgets/mh_appbar_logo_right.dart';
import '../widgets/mh_button.dart';
import '../widgets/mh_check_box.dart';
import '../widgets/mh_snackbar.dart';
import '../widgets/mh_text_form_field.dart';
import '../widgets/provider_sign_in_button.dart';
import 'login_page.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _userName = TextEditingController();
  bool _isCheckboxChecked = false;

  // RegisterPage strings
  String accountSetUp = "Create your free MedHive account";
  String emailText = "E-mail";
  String passwordText = "Password";
  String userNameText = "Username";
  String iHaveReadAndIAgreeWith = "I have read and I agree with";
  String continueText = "Continue";
  String logIn = "Log in";
  String alreadyHaveAnAccount = "Already have an account?";
  String termsAndConditions = "Terms, Conditions and Data Privacy";

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final registerProvider = ref.watch(registerPageProvider);
    bool smallScreen = isSmallScreen(MediaQuery.of(context).size.height);
    return Scaffold(
      appBar: const MhAppBarLogoRight(),
      backgroundColor: MhColors.mhLightGrey,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: MhMargins.mediumMargin,
                      right: MhMargins.mediumMargin,
                      top: smallScreen
                          ? MhMargins.viLogoBottomSmallMargin
                          : MhMargins.viLogoBottomMargin,
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: MhMargins.bigMargin),
                      child: Text(
                        accountSetUp,
                        style: smallScreen
                            ? MhTextStyle.heading4Style
                            : MhTextStyle.heading3Style
                                .copyWith(color: MhColors.mhBlueDark),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: MhMargins.mediumMargin,
                        right: MhMargins.mediumMargin,
                        top: MhMargins.smallMargin),
                    child: MhTextFormField(
                      textFieldType: TextFieldType.email,
                      hintName: emailText,
                      controller: _email,
                      validatorInfo: (email) =>
                          AuthenticationService.emailValidation(email, context),
                      errorMessage: INVALID_EMAIL,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin,
                        vertical: MhMargins.smallMargin),
                    child: MhTextFormField(
                      textFieldType: TextFieldType.password,
                      hintName: passwordText,
                      controller: _password,
                      validatorInfo: (password) =>
                          AuthenticationService.passwordValidation(
                              password, context),
                      errorMessage: INVALID_PASSWORD,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin),
                    child: MhTextFormField(
                      textFieldType: TextFieldType.name,
                      hintName: userNameText,
                      controller: _userName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin,
                        vertical: MhMargins.extraSmallMargin),
                    child: MhCheckbox(
                      isChecked: (bool isChecked) {
                        setState(() {
                          _isCheckboxChecked = isChecked;
                        });
                      },
                      text: Text.rich(
                        TextSpan(
                          text: '$iHaveReadAndIAgreeWith ',
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhAuthGrey),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await UsefulInformationHelper
                                      .termConditionsDialog(context);
                                },
                              text: termsAndConditions,
                              style: MhTextStyle.bodyBoldStyle.copyWith(
                                color: MhColors.mhBlueDark,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        MhMargins.mediumMargin,
                        MhMargins.smallMargin,
                        MhMargins.mediumMargin,
                        smallScreen
                            ? MhMargins.extraSmallMargin
                            : MhMargins.mediumMargin),
                    child: MhButton(
                      text: continueText,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (_isPasswordValid(_password.text.trim())) {
                          if (_isFormValid()) {
                            ref
                                .read(registerPathProvider.notifier)
                                .registerLoadingData();
                            final authMessage = await registerProvider
                                .signUpUserWithEmailAndPassword(
                              _isCheckboxChecked,
                              context,
                              _password.text.trim(),
                              _email.text.trim(),
                              _userName.text.trim(),
                            );
                            if (mounted) {
                              ref
                                  .read(registerPathProvider.notifier)
                                  .registerNotLoadingData();
                              await _navigateUserOnSuccessfulRegistration(
                                  authMessage, context);
                            }
                          }
                        } else {
                          showMhSnackbar(context, PASSWORD_TOO_SHORT);
                        }
                      },
                      viButtonStyle: MhOutlinedButton(),
                      height: MhMargins.mhButtonMediumHeight,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: smallScreen
                            ? MhMargins.extraSmallMargin
                            : MhMargins.mediumMargin),
                    child: ProviderSignInButton(
                      signInType: SignInType.google,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        ref
                            .read(registerPathProvider.notifier)
                            .registerLoadingData();
                        final authMessage = await registerProvider
                            .signUpUserWithGoogle(_isCheckboxChecked, context);
                        if (mounted) {
                          ref
                              .read(registerPathProvider.notifier)
                              .registerNotLoadingData();
                          await _navigateUserOnSuccessfulRegistration(
                              authMessage, context);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: MhMargins.mhStandardPadding),
              child: Text.rich(
                TextSpan(
                  text: '$alreadyHaveAnAccount ',
                  style: MhTextStyle.bodyRegularStyle
                      .copyWith(color: MhColors.mhAuthDarkBlue),
                  children: [
                    TextSpan(
                        text: logIn,
                        style: MhTextStyle.bodyBoldStyle
                            .copyWith(color: MhColors.mhBlueLight),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                                  (route) => false,
                            );
                            _email.clear();
                            _password.clear();
                          })
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _isFormValid() {
    return _formKey.currentState!.validate();
  }

  Future<void> _navigateUserOnSuccessfulRegistration(
      AuthenticationResponseEnum authResponse, BuildContext context) async {
    if (authResponse == AuthenticationResponseEnum.authSuccess) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder:
              (context, animation, secondaryAnimation) =>
          const InitialPageDecider(),
          transitionsBuilder: (context, animation,
              secondaryAnimation, child) {
            return FadeTransition(
                opacity: animation, child: child);
          },
        ),
            (route) => false,
      );
      await CloudFirestoreHelper.updatePrivateUserAvatar(
          'assets/images/male_avatar.png');
      showMhSnackbar(context, SUCCESSFUL_LOGIN, isError: false);
    } else {
      showMhSnackbar(context, authResponse.getMessage(context));
    }
  }

  bool _isPasswordValid(String password) {
    String? passwordErrorMessage =
        AuthenticationService.passwordValidation(password, context);
    if (passwordErrorMessage != null) {
      return false;
    }
    return true;
  }
}
