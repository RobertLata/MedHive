import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medhive/entities/address.dart';
import 'package:medhive/entities/order.dart';
import 'package:medhive/entities/private_user.dart';
import 'package:medhive/pages/setup_location_page.dart';
import 'package:medhive/services/authentication_service.dart';
import 'package:medhive/widgets/mh_address_tile.dart';
import 'package:medhive/widgets/mh_medicine_basket_tile.dart';
import 'package:medhive/widgets/order_summary_tile.dart';
import 'package:medhive/widgets/saved_credit_cards.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../entities/medicine.dart';
import '../entities/pharmacy.dart';
import '../repositories/firebase_repository.dart';
import 'order_state_page.dart';

class MhFinishOrderPage extends ConsumerStatefulWidget {
  final double totalPrice;
  final Pharmacy pharmacy;
  final String orderId;
  const MhFinishOrderPage(
      {super.key,
      required this.totalPrice,
      required this.pharmacy,
      required this.orderId});

  @override
  ConsumerState<MhFinishOrderPage> createState() => _MhFinishOrderPageState();
}

class _MhFinishOrderPageState extends ConsumerState<MhFinishOrderPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Address>>(
        stream: _readAddresses(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Address address = snapshot.data!
                .where((element) =>
                    element.userId == AuthenticationService.currentUserId &&
                    element.isPrimary == true)
                .first;
            return StreamBuilder<List<UserOrder>>(
                stream: _readOrders(),
                builder: (context, snapshot2) {
                  if (snapshot2.hasData) {
                    UserOrder order = snapshot2.data!
                        .where((element) => element.id == widget.orderId)
                        .first;
                    List<Medicine> medicines = [];
                    for (int i = 0; i < widget.pharmacy.medicines.length; i++) {
                      for (int j = 0; j < order.products.length; j++) {
                        if (widget.pharmacy.medicines[i].name ==
                            order.products[j]) {
                          medicines.add(widget.pharmacy.medicines[i]);
                        }
                      }
                    }
                    return Scaffold(
                      backgroundColor: MhColors.mhLightGrey,
                      appBar: AppBar(
                        title: const Text('Finish Order'),
                      ),
                      bottomNavigationBar: InkWell(
                        onTap: () async {
                          final firebaseController =
                              ref.watch(firestoreRepositoryProvider);
                          final currentUser =
                              await firebaseController.readPrivateUser(
                                  AuthenticationService.currentUserId);
                          _showProcessingDialog(
                              context, currentUser, order.id, address);
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: MhMargins.standardPadding),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Send order',
                                      style: MhTextStyle.bodyRegularStyle
                                          .copyWith(color: MhColors.mhWhite),
                                    ),
                                    Text(
                                      '${(widget.totalPrice + widget.pharmacy.deliveryCost).toStringAsFixed(2)} lei',
                                      style: MhTextStyle.bodyRegularStyle
                                          .copyWith(color: MhColors.mhWhite),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      body: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: MhMargins.mhStandardPadding,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MhMargins.standardPadding),
                              child: Text(
                                'Delivery method',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhBlueLight),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: MhMargins.standardPadding),
                              child: Container(
                                color: Colors.white,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              MhMargins.mediumSmallMargin),
                                      child: AddressTile(
                                        addressName: address.name,
                                        addressStreet: address.street,
                                        addressLocation: address.location,
                                        isPrimary: address.isPrimary,
                                        color: MhColors.mhWhite,
                                        shadowColor: MhColors.mhWhite,
                                        surfaceTintColor: MhColors.mhWhite,
                                        onTap: () {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const SetupLocationPage(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return FadeTransition(
                                                    opacity: animation,
                                                    child: child);
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: MhMargins.standardPadding,
                                          right: MhMargins.standardPadding,
                                          bottom: MhMargins.standardPadding),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 13),
                                            child: Icon(
                                              LineIcons.clock,
                                              color: MhColors.mhBlueLight,
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Delivery today',
                                                style: MhTextStyle
                                                    .bodyRegularStyle
                                                    .copyWith(
                                                        color: MhColors
                                                            .mhBlueLight),
                                              ),
                                              const Text(
                                                'As soon as possible',
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MhMargins.standardPadding),
                              child: Text(
                                'Your products',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhBlueLight),
                              ),
                            ),
                            ...medicines.map((medicine) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: MhMargins.mediumSmallMargin,
                                    horizontal: MhMargins.mediumSmallMargin,
                                  ),
                                  child: MhMedicineBasketTile(
                                    medicine: medicine,
                                    noEditOption: true,
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: MhMargins.standardPadding),
                              child: Text(
                                'Payment method',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhBlueLight),
                              ),
                            ),
                            const SavedCreditCards(),
                            Container(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(
                                        MhMargins.standardPadding),
                                    child: Text(
                                      'Order summary',
                                      style: MhTextStyle.heading4Style.copyWith(
                                          color: MhColors.mhBlueRegular),
                                    ),
                                  ),
                                  OrderSummaryTile(
                                      text: 'Products',
                                      price:
                                          widget.totalPrice.toStringAsFixed(2)),
                                  OrderSummaryTile(
                                      text: 'Delivery',
                                      price: widget.pharmacy.deliveryCost
                                          .toStringAsFixed(2)),
                                  OrderSummaryTile(
                                      text: 'Total',
                                      textStyle: MhTextStyle.heroBold
                                          .copyWith(color: MhColors.mhBlueDark),
                                      price: (widget.totalPrice +
                                              widget.pharmacy.deliveryCost)
                                          .toStringAsFixed(2)),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else if (snapshot2.hasError) {
                    return const Center(child: Text("Error"));
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MhColors.mhBlueDark,
                      ),
                    );
                  }
                });
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

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());

  Stream<List<Address>> _readAddresses() => FirebaseFirestore.instance
      .collection('Addresses')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Address.fromJson(doc.data())).toList());

  Future<void> _updatePrivateUser(double? currentBankAccount, double priceToPay,
      double latitude, double longitude) async {
    final collection = FirebaseFirestore.instance.collection('PrivateUsers');

    final docRef = collection.doc(AuthenticationService.currentUserId);

    await docRef.update({
      'bankAccount': (currentBankAccount ?? 0) - priceToPay,
      'addressLat': latitude,
      'addressLong': longitude
    });
  }

  Future<void> _updateOrder(String orderId, String orderAddress,
      double latitude, double longitude) async {
    final collection = FirebaseFirestore.instance.collection('Orders');

    final docRef = collection.doc(orderId);
    final totalPrice = widget.totalPrice + widget.pharmacy.deliveryCost;

    await docRef.update({
      'isOrderPayed': true,
      'totalPrice': totalPrice,
      'location': orderAddress,
      'addressLat': latitude,
      'addressLong': longitude
    });
  }

  void _showProcessingDialog(BuildContext context, PrivateUser? currentUser,
      String orderId, Address address) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool success = false;
        bool insufficientFunds = false;

        return StatefulBuilder(
          builder: (BuildContext context, setState) {
            Future.delayed(const Duration(seconds: 3), () {
              if ((currentUser?.bankAccount ?? 0) >
                  widget.totalPrice + widget.pharmacy.deliveryCost) {
                setState(() {
                  success = true;
                });
                Future.delayed(const Duration(seconds: 3), () async {
                  await _updatePrivateUser(
                      currentUser?.bankAccount,
                      widget.totalPrice + widget.pharmacy.deliveryCost,
                      address.latitude,
                      address.longitude);
                  await _updateOrder(
                      orderId,
                      "${address.street}, ${address.location}",
                      address.latitude,
                      address.longitude);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => OrderStatePage(
                              pharmacy: widget.pharmacy,
                              orderId: widget.orderId,
                            )),
                  );
                });
              } else {
                setState(() {
                  insufficientFunds = true;
                });
                Future.delayed(const Duration(seconds: 3), () {
                  Navigator.of(context).pop();
                });
              }
            });
            return AlertDialog(
              title: Text(
                'Payment Validation',
                style: MhTextStyle.heading4Style
                    .copyWith(color: MhColors.mhPurple),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your request is being processed.",
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhBlueLight),
                  ),
                  const SizedBox(height: MhMargins.standardPadding),
                  if (success)
                    const Icon(Icons.check_circle,
                        color: MhColors.mhGreen, size: 48),
                  if (insufficientFunds)
                    Column(
                      children: [
                        const Icon(Icons.cancel,
                            color: MhColors.mhErrorRed, size: 48),
                        Text(
                          'Insufficient funds',
                          style: MhTextStyle.bodyRegularStyle.copyWith(
                            color: MhColors.mhErrorRed,
                          ),
                        ),
                      ],
                    ),
                  if (!success && !insufficientFunds)
                    const CircularProgressIndicator(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
