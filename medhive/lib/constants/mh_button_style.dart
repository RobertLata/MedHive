import 'package:flutter/material.dart';

import 'mh_colors.dart';
import 'mh_style.dart';

abstract class MhButtonStyle {
  BoxDecoration backgroundStyle() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(30),
    );
  }

  TextStyle textStyle() {
    return MhTextStyle.bodyBoldStyle;
  }
}

class MhFilledButton extends MhButtonStyle {
  @override
  BoxDecoration backgroundStyle() {
    return super.backgroundStyle().copyWith(
      color: MhColors.mhBlueDark,
    );
  }

  @override
  TextStyle textStyle() {
    return super.textStyle().copyWith(
      color: MhColors.mhWhite,
    );
  }
}

class MhOutlinedButton extends MhButtonStyle {
  @override
  BoxDecoration backgroundStyle() {
    return super.backgroundStyle().copyWith(
      border: Border.all(
        color: MhColors.mhBlueDark,
        width: 0.5,
        strokeAlign: BorderSide.strokeAlignInside,
      ),
      color: Colors.transparent,
    );
  }

  @override
  TextStyle textStyle() {
    return super.textStyle().copyWith(
      color: MhColors.mhBlueDark,
    );
  }
}

class MhGradientButton extends MhButtonStyle {
  @override
  BoxDecoration backgroundStyle() {
    return super.backgroundStyle().copyWith(
      gradient: MhColors.mhBlueGreenGradient,
    );
  }

  @override
  TextStyle textStyle() {
    return super.textStyle().copyWith(
      color: MhColors.mhWhite,
    );
  }
}

class MhDisabledButton extends MhButtonStyle {
  @override
  BoxDecoration backgroundStyle() {
    return super.backgroundStyle().copyWith(
      color: MhColors.mhBlueDisabled,
    );
  }

  @override
  TextStyle textStyle() {
    return super.textStyle().copyWith(
      color: MhColors.mhBlueDisabled,
    );
  }
}

class MhCustomizableButtonStyle extends MhButtonStyle {
  final Color backgroundColor;
  final Color textColor;

  MhCustomizableButtonStyle({
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  BoxDecoration backgroundStyle() {
    return super.backgroundStyle().copyWith(
      color: backgroundColor,
    );
  }

  @override
  TextStyle textStyle() {
    return super.textStyle().copyWith(
      color: textColor,
    );
  }
}
