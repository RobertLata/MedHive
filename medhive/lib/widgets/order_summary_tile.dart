import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';

class OrderSummaryTile extends StatelessWidget {
  final String text;
  final String price;
  final TextStyle? textStyle;
  const OrderSummaryTile(
      {super.key, required this.text, required this.price, this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: MhMargins.standardPadding),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(
            thickness: 1,
            color: MhColors.mhBlueLight,
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: MhMargins.standardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: textStyle ??
                      MhTextStyle.bodyRegularStyle
                          .copyWith(color: MhColors.mhPurple),
                ),
                Text(
                  '$price lei',
                  style: textStyle ??
                      MhTextStyle.bodyRegularStyle
                          .copyWith(color: MhColors.mhPurple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
