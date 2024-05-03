import 'package:flutter/material.dart';

import '../constants/mh_button_style.dart';
import '../constants/mh_margins.dart';


class MhButton extends StatelessWidget {
  final String text;
  final bool disabled;
  final MhButtonStyle buttonStyle;
  final double? height;
  final double? width;
  final void Function()? onTap;

  MhButton(
      {super.key,
        required this.text,
        this.disabled = false,
        this.height = MhMargins.mhButtonDefaultHeight,
        this.width,
        this.onTap,
        MhButtonStyle? viButtonStyle})
      : buttonStyle = viButtonStyle ?? MhFilledButton();

  MhButton.outlined({
    super.key,
    required this.text,
    this.disabled = false,
    this.height = MhMargins.mhButtonDefaultHeight,
    this.width,
    this.onTap,
  })  : buttonStyle = MhOutlinedButton();

  MhButton.gradient({
    super.key,
    required this.text,
    this.disabled = false,
    this.height = MhMargins.mhButtonDefaultHeight,
    this.width,
    this.onTap,
  })  : buttonStyle = MhGradientButton();

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: disabled ? () {} : onTap,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(MhMargins.mhStandardBorderRadius)),
        elevation: 0,
        animationDuration: const Duration(milliseconds: 200),
        shadowColor: Colors.transparent,
      ),
      child: Ink(
        decoration: buttonStyle.backgroundStyle(),
        child: Container(
          width: width ?? MediaQuery.of(context).size.width,
          height: height,
          alignment: Alignment.center,
          child: Text(
            text,
            style: buttonStyle.textStyle(),
          ),
        ),
      ),
    );
  }
}
