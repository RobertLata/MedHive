import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/entities/order.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:medhive/widgets/mh_order_tile.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../services/authentication_service.dart';

class OrderPage extends StatelessWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<UserOrder>>(
      stream: _readOrders(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final orders = snapshot.data!
              .where((element) =>
                  element.userId == AuthenticationService.currentUserId)
              .toList();
          return Scaffold(
            appBar: AppBar(title: const MhAppBarLogoRight()),
            body: ListView.builder(
              itemCount: orders.isNotEmpty ? orders.length + 1 : 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(MhMargins.standardPadding),
                    child: Text(
                      "Your orders:",
                      style: MhTextStyle.bodyRegularStyle
                          .copyWith(color: MhColors.mhBlueRegular),
                    ),
                  );
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: MhMargins.extraSmallMargin,
                      horizontal: MhMargins.smallMargin),
                  child: buildAddress(orders[index - 1]),
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
      products: order.products,
      productQuantity: order.productQuantity,
      totalPrice: order.totalPrice,
      onTap: () {});
}
