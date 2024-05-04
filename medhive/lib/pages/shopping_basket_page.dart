import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/pages/mh_prescription_page.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/services/authentication_service.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:medhive/widgets/mh_medicine_basket_tile.dart';

import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';
import '../entities/medicine.dart';
import '../entities/order.dart';
import '../entities/pharmacy.dart';
import 'mh_finish_order_page.dart';

class ShoppingBasketPage extends ConsumerWidget {
  const ShoppingBasketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineListProvider);
    final medicinesWithNoDuplicates = medicineState.medicines.toSet().toList();
    return StreamBuilder<List<Pharmacy>>(
        stream: _readPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              bottomNavigationBar: medicineState.medicines.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        final pharmacies = snapshot.data!;
                        String pharmacyName = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first
                            .name;
                        String pharmacyLogo = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first
                            .logo;
                        String location = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first
                            .address;
                        List<Medicine> medicinesFromPharmacy = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first
                            .medicines;
                        List<dynamic> products = [];
                        for (int i = 0; i < medicinesFromPharmacy.length; i++) {
                          products.add(medicinesFromPharmacy[i].name);
                        }
                        final String docId = generateRandomDocumentId();
                        UserOrder order = UserOrder(
                            id: docId,
                            pharmacyName: pharmacyName,
                            pharmacyLogo: pharmacyLogo,
                            deliveryDate: '',
                            location: location,
                            products: products,
                            productQuantity: [2, 3],
                            totalPrice: 120.5,
                            userId: AuthenticationService.currentUserId!,
                            isPrescriptionValid: false,
                            wasDelivered: false);
                        await _createOrder(order: order);
                        List<Medicine> medicinesThatRequirePrescription = [];
                        for (int i = 0;
                            i < medicinesWithNoDuplicates.length;
                            i++) {
                          if (medicinesWithNoDuplicates[i].needsPrescription) {
                            medicinesThatRequirePrescription
                                .add(medicinesWithNoDuplicates[i]);
                          }
                        }
                        if (medicinesThatRequirePrescription.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MhPrescriptionPage(
                                    medicineThatRequirePrescription:
                                        medicinesThatRequirePrescription,
                                    order: order,
                                  )));
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => MhFinishOrderPage()));
                        }
                      },
                      child: Container(
                        height: 70,
                        width: double.infinity,
                        color: MhColors.mhPurple,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  right: MhMargins.standardPadding),
                              child: Text(
                                'Next step',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhWhite),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
              appBar: const MhAppBarLogoRight(),
              body: medicineState.medicines.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/empty_basket.png',
                          height: 300,
                          width: 300,
                        ),
                        Text(
                          'Your shopping basket is empty',
                          style: MhTextStyle.heading4Style
                              .copyWith(color: MhColors.mhBlueLight),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 60,
                              horizontal: MhMargins.mhStandardPadding),
                          child: MhButton(
                            text: 'Start shopping',
                            onTap: () {
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const TabDecider(
                                            initialIndex: 1,
                                          )),
                                  (route) => false);
                              ref.read(tabIndexProvider.notifier).selectTab(1);
                            },
                          ),
                        ),
                      ],
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.all(MhMargins.standardPadding),
                          child: Text(
                            'My order:',
                            style: MhTextStyle.heading4Style
                                .copyWith(color: MhColors.mhBlueRegular),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: medicinesWithNoDuplicates.length,
                            itemBuilder: (context, index) =>
                                MhMedicineBasketTile(
                              medicine: medicinesWithNoDuplicates[index],
                              isFromPrescriptionPage: false,
                            ),
                          ),
                        ),
                      ],
                    ),
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

  Future<void> _createOrder({required UserOrder order}) async {
    final docOrder =
        FirebaseFirestore.instance.collection('Orders').doc(order.id);

    final addressJson = order.toJson();
    await docOrder.set(addressJson);
  }

  String generateRandomDocumentId() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Orders');

    DocumentReference newDocRef = collection.doc();

    String newDocId = newDocRef.id;

    return newDocId;
  }

  Stream<List<Pharmacy>> _readPharmacies() => FirebaseFirestore.instance
      .collection('Pharmacies')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Pharmacy.fromJson(doc.data())).toList());
}
