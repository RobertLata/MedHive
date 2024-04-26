import 'package:flutter/material.dart';

class MhColors {
  static const Color mhWhite = Color(0xFFFFFFFF);
  static const Color mhLightCream = Color(0xFFE6E4DD);
  static const Color mhLightGrey = Color(0xFFF8F8F8);
  static const Color mhDarkGrey = Color(0xFF4A4646);

  static const Color mhBlueDisabled = Color(0x660a263d);
  static const Color mhBlueLight = Color(0xFF009FCF);
  static const Color mhBlueRegular = Color(0xFF2C5C85);
  static const Color mhBlueDark = Color(0xFF0A263D);

  static const Color mhBlack = Color(0xFF000000);
  static const Color mhGreen = Color(0xFF7CB75E);

  static const Color mhButtonBorder = Color(0xFF263238);

  static const Color mhGoogleSignIn = Color(0xFF676767);
  static const Color mhAuthBorder = Color(0xFF263238);
  static const Color mhAuthDarkBlue = Color(0xFF416C91);
  static const Color mhAuthGrey = Color(0xFF797F8D);
  static const Color mhErrorRed = Color(0xFFDD5D50);
  static const Color mhPurple = Color(0xFF6A53A5);

  static const Gradient mhBlueGreenGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: <Color>[
      mhBlueLight,
      mhGreen,
    ],
  );
}