import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/entities/credit_card.dart';
import 'package:medhive/helpers/cloud_firestore_helper.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';

import '../constants/mh_button_style.dart';
import '../constants/mh_margins.dart';
import '../services/authentication_service.dart';
import '../widgets/mh_button.dart';

class CardValidationPage extends StatefulWidget {
  const CardValidationPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return CardValidationPageState();
  }
}

class CardValidationPageState extends State<CardValidationPage> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final OutlineInputBorder border = OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey.withOpacity(0.7),
      width: 2.0,
    ),
  );
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MhAppBarLogoRight(
        isBackVisible: true,
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CreditCardWidget(
              enableFloatingCard: true,
              glassmorphismConfig: null,
              cardNumber: cardNumber,
              expiryDate: expiryDate,
              cardHolderName: cardHolderName,
              cvvCode: cvvCode,
              frontCardBorder: Border.all(color: Colors.grey),
              backCardBorder: Border.all(color: Colors.grey),
              showBackView: isCvvFocused,
              obscureCardNumber: true,
              obscureCardCvv: true,
              isHolderNameVisible: true,
              cardBgColor: MhColors.mhBlueLight,
              isSwipeGestureEnabled: true,
              onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    CreditCardForm(
                      formKey: formKey,
                      obscureCvv: true,
                      obscureNumber: true,
                      cardNumber: cardNumber,
                      cvvCode: cvvCode,
                      isHolderNameVisible: true,
                      isCardNumberVisible: true,
                      isExpiryDateVisible: true,
                      cardHolderName: cardHolderName,
                      expiryDate: expiryDate,
                      inputConfiguration: const InputConfiguration(
                        cardNumberDecoration: InputDecoration(
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          labelText: 'Card Holder',
                        ),
                      ),
                      onCreditCardModelChange: onCreditCardModelChange,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: MhMargins.mhStandardPadding,
                          horizontal: MhMargins.standardPadding),
                      child: MhButton(
                        text: 'Validate',
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            final String docId = generateRandomDocumentId();

                            CreditCard creditCard = CreditCard(
                                id: docId,
                                cardNumber: cardNumber,
                                expiryDate: expiryDate,
                                cardHolderName: cardHolderName,
                                cvvCode: cvvCode,
                                isPrimary: false,
                                userId: AuthenticationService.currentUser!.uid);

                            await _createCreditCard(creditCard: creditCard);
                            await CloudFirestoreHelper.updatePrimaryCreditCard(creditCard);
                            await _updatePrivateUserBankAccount();
                            Navigator.of(context).pop();
                          }
                        },
                        viButtonStyle: MhOutlinedButton(),
                        height: MhMargins.mhButtonMediumHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel creditCardModel) {
    setState(() {
      cardNumber = creditCardModel.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  Future<void> _createCreditCard({required CreditCard creditCard}) async {
    final docCreditCards =
        FirebaseFirestore.instance.collection('CreditCards').doc(creditCard.id);

    final creditCardJson = creditCard.toJson();
    await docCreditCards.set(creditCardJson);
  }

  String generateRandomDocumentId() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('CreditCards');

    DocumentReference newDocRef = collection.doc();

    String newDocId = newDocRef.id;

    return newDocId;
  }

  Future<void> _updatePrivateUserBankAccount() async {
    final collection = FirebaseFirestore.instance.collection('PrivateUsers');

    final docRef = collection.doc(AuthenticationService.currentUserId);

    await docRef.update({'bankAccount': 1500.50});
  }
}
