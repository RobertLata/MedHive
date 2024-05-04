import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/string_constants.dart';
import 'package:medhive/pages/initial_page_decider.dart';
import 'package:medhive/pages/register_page.dart';
import 'package:medhive/services/authentication_service.dart';
import '../../../helpers/screen_size_helper.dart';
import '../constants/authentication_response.dart';
import '../constants/mh_button_style.dart';
import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../controllers/login_controller.dart';
import '../controllers/register_path_provider.dart';
import '../widgets/mh_appbar_logo_right.dart';
import '../widgets/mh_button.dart';
import '../widgets/mh_snackbar.dart';
import '../widgets/mh_text_form_field.dart';
import '../widgets/provider_sign_in_button.dart';
import 'forgot_password_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final _email = TextEditingController();
  final _password = TextEditingController();

  String logIn = "Hey there,\nWelcome to MedHive";
  String emailText = "E-mail";
  String passwordText = "Password";
  String forgotPassword = "Forgot password?";
  String continueText = "Continue";
  String noAccountText = "Don't have an account?";
  String signupText = "Sign up";

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final logInProvider = ref.watch(logInPageProvider);
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
                        logIn,
                        style: smallScreen
                            ? MhTextStyle.heading4Style
                            : MhTextStyle.heading3Style
                                .copyWith(color: MhColors.mhBlueDark),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin),
                    child: MhTextFormField(
                      textFieldType: TextFieldType.email,
                      hintName: emailText,
                      controller: _email,
                      validatorInfo: (email) =>
                          AuthenticationService.emailValidation(email, context),
                      errorMessage: INVALID_EMAIL,
                    ),
                  ),
                  const SizedBox(
                    height: MhMargins.mediumMargin,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin),
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
                    padding: const EdgeInsets.only(
                        bottom: MhMargins.smallMargin,
                        left: MhMargins.mediumMargin,
                        right: MhMargins.mediumMargin),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text.rich(
                        TextSpan(
                          text: forgotPassword,
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhAuthGrey),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (context) => ForgotPasswordPage(
                                            emailText: _email.text.trim(),
                                          )));
                              _password.clear();
                            },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MhMargins.mediumMargin,
                        vertical: smallScreen
                            ? MhMargins.authPagesSmallMargin
                            : MhMargins.authPagesHighMargin),
                    child: MhButton(
                      text: continueText,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        if (_isFormValid()) {
                          ref
                              .read(registerPathProvider.notifier)
                              .registerNotLoadingData();
                          final authResponse =
                              await logInProvider.logInUserWithEmailAndPassword(
                            _email.text.trim(),
                            _password.text.trim(),
                          );

                          if (mounted) {
                            await _navigateUserOnSuccessfulLogIn(
                                authResponse, context);
                          }
                        }
                      },
                      viButtonStyle: MhOutlinedButton(),
                      height: MhMargins.mhButtonMediumHeight,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: smallScreen
                            ? MhMargins.smallMargin
                            : MhMargins.mediumMargin),
                    child: ProviderSignInButton(
                      signInType: SignInType.google,
                      onTap: () async {
                        FocusScope.of(context).unfocus();
                        ref
                            .read(registerPathProvider.notifier)
                            .registerNotLoadingData();
                        final authMessage =
                            await logInProvider.logInUserWithGoogle(context);

                        if (mounted) {
                          await _navigateUserOnSuccessfulLogIn(
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
                  text: '$noAccountText ',
                  style: MhTextStyle.bodyRegularStyle
                      .copyWith(color: MhColors.mhAuthDarkBlue),
                  children: [
                    TextSpan(
                        text: signupText,
                        style: MhTextStyle.bodyBoldStyle
                            .copyWith(color: MhColors.mhBlueLight),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => const RegisterPage()),
                                (route) => false);
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

  Future<void> _navigateUserOnSuccessfulLogIn(
      AuthenticationResponseEnum authResponse, BuildContext context) async {
    if (authResponse == AuthenticationResponseEnum.authSuccess) {
      ref.read(logInPageProvider);
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const InitialPageDecider()),
            (route) => false);
        showMhSnackbar(context, SUCCESSFUL_LOGIN,
            isError: false);
      }
    } else {
      showMhSnackbar(context, authResponse.getMessage(context));
    }
  }
}
