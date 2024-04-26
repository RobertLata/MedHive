import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_style.dart';

class MhAccountTile extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final IconData icon;
  const MhAccountTile(
      {super.key, required this.text, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: const RoundedRectangleBorder(),
      elevation: 1,
      child: ListTileTheme(
        shape: const RoundedRectangleBorder(),
        child: ListTile(
          leading: Icon(
            icon,
            color: MhColors.mhBlueLight,
          ),
          title: Text(
            text,
            style:
                MhTextStyle.bodyRegularStyle.copyWith(color: MhColors.mhPurple),
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
