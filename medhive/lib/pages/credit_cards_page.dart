import 'package:flutter/material.dart';
import 'package:medhive/entities/credit_card.dart';
import 'package:medhive/widgets/saved_credit_cards.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_style.dart';

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({super.key});

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  List<CreditCard> cards = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
              backgroundColor: MhColors.mhWhite,
              appBar: AppBar(
                title: const Text(
                  'Credit Cards',
                  style: MhTextStyle.heading4Style,
                ),
                leading: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              body: const SavedCreditCards()
    );
  }
}
