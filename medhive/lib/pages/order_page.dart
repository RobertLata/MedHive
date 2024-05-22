import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/entities/order.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:medhive/widgets/mh_order_tile.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../controllers/tab_controller.dart';
import '../services/authentication_service.dart';
import '../widgets/mh_button.dart';

class OrderPage extends ConsumerWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<UserOrder>>(
      stream: _readOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!
              .where((element) =>
                  element.userId == AuthenticationService.currentUserId)
              .toList();
          return Scaffold(
            backgroundColor: MhColors.mhWhite,
            appBar: AppBar(title: const MhAppBarLogoRight()),
            body: orders.every((order) => (order.orderState == 'In Progress'))
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Make your first order',
                        style: MhTextStyle.heading4Style
                            .copyWith(color: MhColors.mhBlueLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 60,
                            horizontal: MhMargins.mhStandardPadding),
                        child: MhButton(
                          text: 'Discover pharmacies',
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
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
                : ListView.builder(
                    itemCount: orders.isNotEmpty ? orders.length + 1 : 1,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding:
                              const EdgeInsets.all(MhMargins.standardPadding),
                          child: Text(
                            "Your orders:",
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhBlueRegular),
                          ),
                        );
                      }
                      int adjustedIndex = index - 1;
                      return Visibility(
                        visible: orders[adjustedIndex].orderState ==
                                'Delivered' ||
                            orders[adjustedIndex].orderState == 'In Delivery',
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: MhMargins.extraSmallMargin,
                              horizontal: MhMargins.smallMargin),
                          child: buildAddress(orders[adjustedIndex]),
                        ),
                      );
                    },
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
      },
    );
  }

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());

  Widget buildAddress(UserOrder order) => OrderTile(
      id: order.id,
      pharmacyName: order.pharmacyName,
      pharmacyLogo: order.pharmacyLogo,
      deliveryDate: order.deliveryDate,
      location: order.location,
      deliveryState: order.orderState,
      products: order.products,
      productQuantity: order.productQuantity,
      totalPrice: order.totalPrice);
}
