import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/order.dart';
import 'package:medhive/entities/pharmacy.dart';
import 'package:medhive/pages/map_page.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/widgets/comment_section.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:latlong2/latlong.dart';

import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';
import '../widgets/rating_feedback.dart';

class OrderStatePage extends ConsumerStatefulWidget {
  final Pharmacy pharmacy;
  final String orderId;
  const OrderStatePage({super.key, required this.pharmacy, required this.orderId});

  @override
  ConsumerState<OrderStatePage> createState() => _OrderStatePageState();
}

class _OrderStatePageState extends ConsumerState<OrderStatePage> {
  late Pharmacy? pharmacy = widget.pharmacy;
  double ratingValue = 3.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) =>
                const TabDecider(
              initialIndex: 2,
            ),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
          (route) => false,
        );
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
              resizeToAvoidBottomInset: false,
              backgroundColor: MhColors.mhWhite,
              appBar: MhAppBarLogoRight(
                isBackVisible: true,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          const TabDecider(
                        initialIndex: 2,
                      ),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    ),
                    (route) => false,
                  );
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    order.orderState == 'In Progress'
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                'Your order: ${order.id} is in progress.',
                                style: MhTextStyle.heading4Style
                                    .copyWith(color: MhColors.mhBlueRegular),
                              ),
                              Text(
                                'As soon as we finish packing it a rider will pick it up.',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhBlueLight),
                              ),
                              Lottie.asset(
                                'lotties/medicine_packing.json',
                                width: 300,
                                height: 300,
                                fit: BoxFit.contain,
                              ),
                            ],
                          )
                        : order.orderState == 'In Delivery'
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your order: ${order.id} will be delivered soon',
                                    style: MhTextStyle.heading4Style.copyWith(
                                        color: MhColors.mhBlueRegular),
                                  ),
                                  order.riderLat != null &&
                                          order.riderLong != null
                                      ? InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        MapPage(
                                                          riderAddress: LatLng(
                                                              order.riderLat ??
                                                                  0,
                                                              order.riderLong ??
                                                                  0),
                                                          deliveryAddress:
                                                              LatLng(
                                                              order.addressLat ?? 0,
                                                                  order.addressLong ?? 0),
                                                          orderId: order.id,
                                                        )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    MhMargins.standardPadding),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                const Icon(
                                                  Icons.location_on,
                                                  color: MhColors.mhPurple,
                                                ),
                                                Text(
                                                  'See on map',
                                                  style: MhTextStyle
                                                      .bodySmallRegularStyle
                                                      .copyWith(
                                                          color: MhColors
                                                              .mhPurple),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                  Lottie.asset(
                                    'lotties/in_delivery.json',
                                    width: 300,
                                    height: 300,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              )
                            : order.orderState == 'Delivered'
                                ? Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Your order: ${order.id} has been delivered successfully.',
                                        style: MhTextStyle.heading4Style
                                            .copyWith(
                                                color: MhColors.mhBlueRegular),
                                      ),
                                      Lottie.asset(
                                        'lotties/order_delivered.json',
                                        width: 200,
                                        height: 200,
                                        fit: BoxFit.contain,
                                      ),
                                      Text(
                                        'Rate products and delivery',
                                        style: MhTextStyle.bodyRegularStyle
                                            .copyWith(
                                                color: MhColors.mhBlueLight),
                                      ),
                                      RatingFeedback(
                                        ratingValue: (double returnedValue) {
                                          setState(() {
                                            ratingValue = returnedValue;
                                          });
                                        },
                                      ),
                                      CommentSection(
                                        pharmacy: pharmacy,
                                        rating: ratingValue,
                                      ),
                                    ],
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
