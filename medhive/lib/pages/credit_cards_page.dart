import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/entities/credit_card.dart';
import 'package:medhive/helpers/cloud_firestore_helper.dart';
import 'package:medhive/pages/card_validation_page.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../services/authentication_service.dart';
import '../widgets/mh_credit_card_tile.dart';

class CreditCardsPage extends StatefulWidget {
  const CreditCardsPage({super.key});

  @override
  State<CreditCardsPage> createState() => _CreditCardsPageState();
}

class _CreditCardsPageState extends State<CreditCardsPage> {
  List<CreditCard> cards = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CreditCard>>(
        stream: _readCreditCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userCreditCards = snapshot.data!.where((element) =>
                element.userId == AuthenticationService.currentUserId);
            return Scaffold(
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
              body: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.add, color: MhColors.mhBlueLight),
                    title: const Text(
                      'Add new Credit Card',
                      style: MhTextStyle.bodyRegularStyle,
                    ),
                    trailing: const Icon(Icons.chevron_right,
                        color: MhColors.mhBlueDark),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const CardValidationPage()));
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(MhMargins.standardPadding),
                    child: userCreditCards.isNotEmpty
                        ? const Text(
                            "Your saved Credit Cards:",
                            style: MhTextStyle.bodyRegularStyle,
                          )
                        : null,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: MhMargins.smallMargin),
                      child: ListView(
                        children:
                            userCreditCards.map(buildCreditCards).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Scaffold(body: Center(child: Text("Error")));
          } else {
            return const Scaffold(
              body: Center(
                  child: CircularProgressIndicator(
                color: MhColors.mhBlueDark,
              )),
            );
          }
        });
  }

  Stream<List<CreditCard>> _readCreditCards() => FirebaseFirestore.instance
      .collection('CreditCards')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => CreditCard.fromJson(doc.data())).toList());

  Widget buildCreditCards(CreditCard creditCard) => CreditCardTile(
        cardNumber: creditCard.cardNumber,
        expiryDate: creditCard.expiryDate,
        cardHolderName: creditCard.cardHolderName,
        cvvCode: creditCard.cvvCode,
        isPrimary: creditCard.isPrimary,
        onTap: () => {CloudFirestoreHelper.updatePrimaryCreditCard(creditCard)},
        onCloseTap: () => {_deleteCreditCard(creditCard)},
      );

  Future<void> _deleteCreditCard(CreditCard creditCard) async {
    final collection = FirebaseFirestore.instance.collection('CreditCards');

    final docRef = collection.doc(creditCard.id);

    await docRef.delete();
  }
}
