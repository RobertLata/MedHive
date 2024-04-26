import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_style.dart';

class UsefulInformationHelper {
  static Future<void> termConditionsDialog(BuildContext context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Terms, Conditions and Data Privacy',
              style: MhTextStyle.heading4Style
                  .copyWith(color: MhColors.mhBlueDark)),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    "By using the MedHive app, you agree to the following terms:\n\n"
                        "1. Use of Service: MedHive provides a mobile platform for the delivery of pharmaceutical products. Our services are subject to availability, and we reserve the right to refuse service at our discretion.\n\n"
                        "2. User Obligations: You agree to provide accurate information for the services provided and to use MedHive only for lawful purposes.\n\n"
                        "3. Privacy: We respect your privacy and your personal information. Your use of the app signifies your consent to our privacy policies.\n\n"
                        "4. Intellectual Property: MedHive and its original content, features, and functionality are owned by the MedHive Company and are protected by international copyright and trademark laws.\n\n"
                        "5. Amendments: These Terms may be updated from time to time. Your continued use of the app will be regarded as acceptance of our updated terms.\n\n"
                        "6. Governing Law: Your use of MedHive and any dispute arising out of such use is subject to the laws of the jurisdiction where our company is established.",
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhBlueDark)),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Close",
                  style: MhTextStyle.bodyBoldStyle
                      .copyWith(color: MhColors.mhBlueDark)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

}