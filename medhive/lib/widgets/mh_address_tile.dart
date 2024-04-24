import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';

class AddressTile extends StatelessWidget {
  final String addressName;
  final String addressStreet;
  final String addressLocation;
  final bool isPrimary;
  final VoidCallback onTap;
  final VoidCallback onCloseTap;

  const AddressTile({
    super.key,
    required this.addressName,
    required this.addressStreet,
    required this.addressLocation,
    required this.isPrimary,
    required this.onTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MhMargins.mhStandardBorderRadius),
        side: BorderSide(
            color: isPrimary ? MhColors.mhBlueLight : Colors.transparent),
      ),
      child: ListTile(
        leading: Icon(isPrimary ? Icons.home : Icons.location_on,
            color: isPrimary ? MhColors.mhBlueLight : null),
        title: Text(
          addressName,
          style: TextStyle(color: isPrimary ? MhColors.mhBlueLight : null),
        ),
        subtitle: Text('$addressStreet, $addressLocation'),
        trailing: IconButton(
          icon: Icon(Icons.close,
              color: isPrimary ? MhColors.mhBlueLight : MhColors.mhDarkGrey),
          onPressed: onCloseTap,
        ),
        onTap: onTap,
      ),
    );
  }
}
