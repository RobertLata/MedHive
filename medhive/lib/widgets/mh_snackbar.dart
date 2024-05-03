import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';

void showMhSnackbar(BuildContext context, String message,
    {bool isError = true, VoidCallback? onTap}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: InkWell(
      onTap: onTap,
      child: Text(message,
          style: MhTextStyle.textSnackbarStyle),
    ),
    backgroundColor: isError ? MhColors.mhErrorRed : MhColors.mhGreen,
    padding: const EdgeInsets.symmetric(
        vertical: MhMargins.snackbarPaddingVertical,
        horizontal: MhMargins.snackbarPaddingHorizontal),
    margin: const EdgeInsets.only(
        left: MhMargins.mediumMargin,
        right: MhMargins.mediumMargin,
        bottom: MhMargins.mediumMargin),
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10))),
    behavior: SnackBarBehavior.floating,
  ));
}
