import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';

class CreditCardTile extends StatelessWidget {
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvvCode;
  final bool isPrimary;
  final VoidCallback onTap;
  final VoidCallback onCloseTap;

  const CreditCardTile({
    super.key,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvvCode,
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
        leading: Icon(Icons.credit_card,
            color: isPrimary ? MhColors.mhBlueLight : null),
        title: Text(
          cardNumber,
          style: TextStyle(color: isPrimary ? MhColors.mhBlueLight : null),
        ),
        subtitle: Text(
            'Expires at: $expiryDate\nOwner: $cardHolderName'),
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
