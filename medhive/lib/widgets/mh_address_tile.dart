import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';

class AddressTile extends StatelessWidget {
  final String addressName;
  final String addressStreet;
  final String addressLocation;
  final bool isPrimary;
  final VoidCallback? onTap;
  final VoidCallback? onCloseTap;
  final Color? color;
  final Color? shadowColor;
  final Color? surfaceTintColor;

  const AddressTile(
      {super.key,
      required this.addressName,
      required this.addressStreet,
      required this.addressLocation,
      required this.isPrimary,
      this.onTap,
      this.onCloseTap,
      this.color,
      this.shadowColor,
      this.surfaceTintColor});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: color != null ? 0 : 1,
      color: color,
      shadowColor: shadowColor,
      surfaceTintColor: surfaceTintColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MhMargins.mhStandardBorderRadius),
        side: onCloseTap != null
            ? BorderSide(
                color: isPrimary ? MhColors.mhBlueLight : Colors.transparent)
            : BorderSide.none,
      ),
      child: ListTile(
        leading: Icon(isPrimary ? Icons.home : Icons.location_on,
            color: isPrimary ? MhColors.mhBlueLight : null),
        title: Text(
          addressName,
          style: TextStyle(color: isPrimary ? MhColors.mhBlueLight : null),
        ),
        subtitle: Text('$addressStreet, $addressLocation'),
        trailing: onCloseTap != null
            ? IconButton(
                icon: Icon(Icons.close,
                    color:
                        isPrimary ? MhColors.mhBlueLight : MhColors.mhDarkGrey),
                onPressed: onCloseTap,
              )
            : const Icon(Icons.keyboard_arrow_down_outlined,
                color: MhColors.mhBlueLight),
        onTap: onTap,
      ),
    );
  }
}
