import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mh_colors.dart';
import 'mh_style.dart';

ThemeData customTheme = ThemeData(
  //colors
  disabledColor: MhColors.mhBlueDisabled,
  primaryColor: MhColors.mhBlueRegular,
  highlightColor: MhColors.mhBlueRegular,
  splashColor: Colors.transparent,
  textTheme: GoogleFonts.poppinsTextTheme(),

  //appbar
  appBarTheme: const AppBarTheme(
    backgroundColor: MhColors.mhWhite,
    elevation: 0,
    foregroundColor: MhColors.mhBlueDark,
    toolbarTextStyle: MhTextStyle.heading4Style,
  ),

  //bottom appbar
  bottomAppBarTheme: const BottomAppBarTheme(
    color: MhColors.mhLightCream,
    elevation: 0,
  ),

  snackBarTheme: SnackBarThemeData(
    contentTextStyle:
    MhTextStyle.bodyRegularStyle.copyWith(color: MhColors.mhBlueDark),
    elevation: 0,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(25))),
    backgroundColor: MhColors.mhLightCream,
  ),

  //dialog theme
  dialogTheme: const DialogTheme(
    backgroundColor: MhColors.mhWhite,
    titleTextStyle: MhTextStyle.heading4Style,
    contentTextStyle: MhTextStyle.bodyRegularStyle,
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(30),
      ),
    ),
  ),
);
