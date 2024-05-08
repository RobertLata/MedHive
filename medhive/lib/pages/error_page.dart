import 'package:flutter/material.dart';
import 'package:medhive/constants/string_constants.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_style.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MhColors.mhWhite,
        body: Center(
          child: Text(AUTH_ERROR_MESSAGE,
              style: MhTextStyle.heading4Style.copyWith(color: Colors.red)),
        ),
      ),
    );
  }
}