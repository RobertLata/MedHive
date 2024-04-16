import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../constants/mh_margins.dart';

enum SignInType { google }

class ProviderSignInButton extends StatelessWidget {
  final SignInType signInType;
  final void Function() onTap;
  const ProviderSignInButton(
      {super.key, required this.signInType, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MhMargins.mediumMargin),
      child: SizedBox(
        height: MhMargins.mhButtonMediumHeight,
        width: double.infinity,
        child: SignInButton(
          Buttons.Google,
          onPressed: onTap,
          text: "Sign in with Google",
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(MhMargins.mhStandardBorderRadius),
          ),
        ),
      ),
    );
  }
}
