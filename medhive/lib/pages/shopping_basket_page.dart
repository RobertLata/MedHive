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

class ShoppingBasketPage extends ConsumerStatefulWidget {
  const ShoppingBasketPage({super.key});

  @override
  ConsumerState<ShoppingBasketPage> createState() => _ShoppingBasketPageState();
}

class _ShoppingBasketPageState extends ConsumerState<ShoppingBasketPage> {
  late List<int> productsQuantity;
  late List<double> medicinePrices;
  late double totalPrice;

  @override
  void initState() {
    super.initState();
    productsQuantity = [];
    medicinePrices = [];
    totalPrice = 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineListProvider);
    final medicinesWithNoDuplicates = medicineState.medicines.toSet().toList();

    return StreamBuilder<List<Pharmacy>>(
        stream: _readPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              backgroundColor: MhColors.mhWhite,
              bottomNavigationBar: medicineState.medicines.isEmpty
                  ? const SizedBox()
                  : InkWell(
                      onTap: () async {
                        final pharmacies = snapshot.data!;
                        Pharmacy pharmacy = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first;
                        List<Medicine> medicinesFromPharmacy = pharmacies
                            .where((element) =>
                                element.id == medicinesWithNoDuplicates[0].id)
                            .first
                            .medicines;
                        List<dynamic> products = [];
                        totalPrice = 0.0;
                        productsQuantity = [];

                        Map<String, int> lastMedicineQuantities = {};

                        for (Medicine medicine in medicineState.medicines) {
                          lastMedicineQuantities[medicine.name] =
                              medicineState.getMedicineDose(medicine);
                        }
                        lastMedicineQuantities.forEach((name, quantity) {
                          productsQuantity.add(quantity);
                        });
                        medicineState.medicines.forEach((medicine) {
                          totalPrice += medicine.price;
                        });
                        for (int i = 0; i < productsQuantity.length; i++) {
                          products.add(medicinesFromPharmacy[i].name);
                        }
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
                          final String docId = generateRandomDocumentId();
                          UserOrder order = UserOrder(
                              id: docId,
                              pharmacyName: pharmacy.name,
                              pharmacyLogo: pharmacy.logo,
                              deliveryDate: '',
                              location: pharmacy.address,
                              products: products,
                              productQuantity: productsQuantity,
                              totalPrice: totalPrice,
                              userId: AuthenticationService.currentUserId!,
                              orderState: 'In Progress');
                          await _createOrder(order: order);
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MhPrescriptionPage(
                                medicineThatRequirePrescription:
                                    medicinesThatRequirePrescription,
                                order: order,
                                pharmacy: pharmacy,
                                totalPrice: totalPrice,
                                orderId: docId,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
                        } else {
                          final String docId = generateRandomDocumentId();
                          UserOrder order = UserOrder(
                              id: docId,
                              pharmacyName: pharmacy.name,
                              pharmacyLogo: pharmacy.logo,
                              deliveryDate: '',
                              location: pharmacy.address,
                              products: products,
                              productQuantity: productsQuantity,
                              totalPrice: totalPrice,
                              userId: AuthenticationService.currentUserId!,
                              orderState: 'In Progress',
                              isPrescriptionValid: true);
                          await _createOrder(order: order);
                          Navigator.of(context).push(
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                                      MhFinishOrderPage(
                                totalPrice: totalPrice,
                                pharmacy: pharmacy,
                                orderId: docId,
                              ),
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                return FadeTransition(
                                    opacity: animation, child: child);
                              },
                            ),
                          );
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
                                PageRouteBuilder(
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      const TabDecider(
                                    initialIndex: 0,
                                  ),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                                (route) => false,
                              );
                              ref.read(tabIndexProvider.notifier).selectTab(0);
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
                              noEditOption: false,
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
