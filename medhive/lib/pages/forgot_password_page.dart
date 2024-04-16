import 'package:flutter/material.dart';
import 'package:medhive/services/authentication_service.dart';

import '../constants/authentication_response.dart';
import '../constants/mh_button_style.dart';
import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../widgets/mh_appbar_logo_right.dart';
import '../widgets/mh_button.dart';
import '../widgets/mh_snackbar.dart';
import '../widgets/mh_text_form_field.dart';
import 'login_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String emailText;
  const ForgotPasswordPage({super.key, required this.emailText});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // ForgotPasswordPage constants
  String receiveEmailPasswordReset = "Receive an email to reset your password";
  String emailText = "E-mail";
  String resetPassword = "Reset password";
  String successfulEmailSent = "Email sent successfully";

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.emailText;
  }

  @override
  Widget build(BuildContext context) => WillPopScope(
        onWillPop: () async {
          _popCurrentPage();
          return true;
        },
        child: Scaffold(
          backgroundColor: MhColors.mhWhite,
          appBar: MhAppBarLogoRight(
            isBackVisible: true,
            onPressed: _popCurrentPage,
          ),
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(MhMargins.mediumMargin),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: MhMargins.mhLogoBottomMargin),
                        child: Text(
                          receiveEmailPasswordReset,
                          style: MhTextStyle.heading3Style
                              .copyWith(color: MhColors.mhBlueDark),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: MhMargins.mhStandardPadding),
                      child: MhTextFormField(
                        textFieldType: TextFieldType.email,
                        hintName: emailText,
                        controller: _emailController,
                        validatorInfo: (email) =>
                            AuthenticationService.emailValidation(
                                email, context),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 200.0),
                      child: MhButton(
                        text: resetPassword,
                        onTap: _sendPasswordReset,
                        viButtonStyle: MhOutlinedButton(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  void _popCurrentPage() {
    //Used pushReplacement instead of pop to reset the validators when we go back to login page
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()));
    _emailController.clear();
  }

  Future<void> _sendPasswordReset() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    await AuthenticationService()
        .resetPassword(_emailController.text.trim(), context)
        .then((value) {
      if (value == AuthenticationResponseEnum.emailSentSuccessfully) {
        showMhSnackbar(context, value.getMessage(context), isError: false);
      } else {
        showMhSnackbar(context, value.getMessage(context));
      }
    });
  }
}
