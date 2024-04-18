import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mh_colors.dart';

//display type/heroes
class MhTextStyle {
  static const TextStyle heroRegular = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
  );

  static const TextStyle heroBold = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.5,
  );

//headings
  static const TextStyle heading1Style = TextStyle(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.4,
  );

  static const TextStyle heading2Style = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.3,
    height: 1.38,
  );

  static const TextStyle heading3Style = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w500,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static const TextStyle heading4Style = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.2,
  );

//body 16
  static const TextStyle bodyRegularStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyBoldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.24,
  );

  static const TextStyle bodyAuthStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

//body 16 italic
  static const TextStyle bodyItalicStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle bodyItalicBoldStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle bottomNavBarText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    fontStyle: FontStyle.normal,
    height: 1.5,
  );

//body small 14
  static const TextStyle bodySmallRegularStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
  );

  static const TextStyle bodySmallBoldStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
  );

  static const TextStyle bodySmallItalicStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    fontStyle: FontStyle.italic,
  );

  static const TextStyle bodySmallItalicBoldStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    fontStyle: FontStyle.italic,
  );

//body extra small
  static const TextStyle bodyExtraSmallRegularStyle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w200,
    letterSpacing: 0.4,
  );

//uppercase small
  static const TextStyle bodyUpperCaseStyle = TextStyle(
    fontSize: 12,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.6,
  );

  //appbar style
  static const TextStyle appBarStyle = TextStyle(
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.2,
      height: 1.1);

  //snackbar
  static TextStyle textSnackbarStyle = GoogleFonts.poppins(
    color: MhColors.mhWhite,
    fontWeight: FontWeight.w300,
    fontSize: 16,
  );

  //TextFormField error text style
  static const TextStyle textFieldErrorStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w300,
    color: MhColors.mhErrorRed,
  );
}
