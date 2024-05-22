import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../entities/credit_card.dart';
import '../helpers/cloud_firestore_helper.dart';
import '../pages/card_validation_page.dart';
import '../services/authentication_service.dart';
import 'mh_credit_card_tile.dart';

class SavedCreditCards extends StatelessWidget {
  const SavedCreditCards({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<CreditCard>>(
        stream: _readCreditCards(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userCreditCards = snapshot.data!.where((element) =>
                element.userId == AuthenticationService.currentUserId);
            return Column(
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
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                        const CardValidationPage(),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    );
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: MhMargins.smallMargin),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: userCreditCards.map(buildCreditCards).toList(),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: MhColors.mhBlueDark,
              ),
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
