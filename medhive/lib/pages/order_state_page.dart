import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/order.dart';
import 'package:medhive/entities/pharmacy.dart';
import 'package:medhive/pages/rider_location_page.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';

class OrderStatePage extends ConsumerStatefulWidget {
  final Pharmacy? pharmacy;
  final String orderId;
  const OrderStatePage({super.key, this.pharmacy, required this.orderId});

  @override
  ConsumerState<OrderStatePage> createState() => _OrderStatePageState();
}

class _OrderStatePageState extends ConsumerState<OrderStatePage> {
  late Pharmacy? pharmacy = widget.pharmacy;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => const TabDecider(
                      initialIndex: 2,
                    )),
            (route) => false);
        ref.read(tabIndexProvider.notifier).selectTab(2);
        pharmacy?.medicines.forEach((medicine) {
          ref
              .read(medicineListProvider.notifier)
              .removeMedicineFromList(medicine);
        });

        return true;
      },
      child: StreamBuilder<List<UserOrder>>(
        stream: _readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final order = snapshot.data!
                .where((element) => element.id == widget.orderId)
                .first;
            return Scaffold(
              backgroundColor: MhColors.mhWhite,
              appBar: MhAppBarLogoRight(
                isBackVisible: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const TabDecider(
                                initialIndex: 2,
                              )),
                      (route) => false);
                  ref.read(tabIndexProvider.notifier).selectTab(2);
                  pharmacy?.medicines.forEach((medicine) {
                    ref
                        .read(medicineListProvider.notifier)
                        .removeMedicineFromList(medicine);
                  });
                },
              ),
              body: Padding(
                padding: const EdgeInsets.all(MhMargins.standardPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    order.orderState == 'In Progress'
                        ? Text(
                            'The order: ${order.id} is in progress.\nAs soon as we finish packing it a rider will pick it up.',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhBlueRegular),
                          )
                        : order.orderState == 'In Delivery'
                            ? Column(
                                children: [
                                  Text(
                                    'Your order will be delivered soon',
                                    style: MhTextStyle.bodyRegularStyle
                                        .copyWith(
                                            color: MhColors.mhBlueRegular),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                              builder: (context) => MapPage(
                                                    deliveryAddress: LatLng(
                                                        45.7409, 21.2007),
                                                  )));
                                    },
                                    child: Text(
                                      'See on map',
                                      style: MhTextStyle.bodySmallRegularStyle
                                          .copyWith(color: MhColors.mhPurple),
                                    ),
                                  )
                                ],
                              )
                            : order.orderState == 'Delivered'
                                ? Text(
                                    'The order: ${order.id} has been delivered successfully.',
                                    style: MhTextStyle.bodyRegularStyle
                                        .copyWith(
                                            color: MhColors.mhBlueRegular),
                                  )
                                : const SizedBox(),
                  ],
                ),
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
      ),
    );
  }

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());
}
