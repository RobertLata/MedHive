import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';

class MhAppBarLogoRight extends StatelessWidget implements PreferredSizeWidget {
  final bool isBackVisible;
  final void Function()? onPressed;

  const MhAppBarLogoRight({
    super.key,
    this.isBackVisible = false,
    this.onPressed,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      title: Row(
        children: [
          if (isBackVisible)
            Container(
              decoration: BoxDecoration(
                color: MhColors.mhWhite,
                borderRadius: BorderRadius.circular(30),
              ),
              child: IconButton(
                hoverColor: MhColors.mhWhite,
                highlightColor: MhColors.mhWhite,
                splashRadius: 10,
                icon: const Icon(
                  Icons.arrow_left,
                  color: MhColors.mhBlueRegular,
                ),
                onPressed: onPressed,
              ),
            ),
          const Spacer(),
          SizedBox(
            width: MhMargins.appBarItemSize,
            child: Image.asset('assets/images/mh_logo.png'),
          ),
        ],
      ),
    );
  }
}
