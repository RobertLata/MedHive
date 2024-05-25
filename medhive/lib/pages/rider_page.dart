import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:medhive/pages/rider_location_page.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:latlong2/latlong.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../entities/order.dart';
import '../helpers/location_helper.dart';
import '../repositories/firebase_repository.dart';
import '../services/authentication_service.dart';
import 'login_page.dart';

class RiderPage extends ConsumerWidget {
  const RiderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseController = ref.watch(firestoreRepositoryProvider);
    return StreamBuilder<List<UserOrder?>>(
        stream: _readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserOrder? order;
            List<UserOrder?>? orders = snapshot.data;
            if (orders != null && orders.isNotEmpty) {
              order = orders
                  .where((order) =>
                      (order?.deliveryRiderId ==
                          AuthenticationService.currentUserId) &&
                      order?.orderState == 'In Delivery')
                  .firstOrNull;
            }
            return order == null
                ? Scaffold(
                    body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "No order to deliver yet",
                        style: MhTextStyle.heading3Style
                            .copyWith(color: MhColors.mhBlueRegular),
                      ),
                      const SizedBox(
                        height: MhMargins.mhStandardPadding,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await AuthenticationService().signOut();
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 1.0),
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.zero, // No border radius
                            ),
                          ),
                          child: Text(
                            'Sign out',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhErrorRed),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await firebaseController.deletePrivateUser();
                            await AuthenticationService().deleteAccount();
                            Navigator.of(context).pushAndRemoveUntil(
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation, secondaryAnimation) =>
                                const LoginPage(),
                                transitionsBuilder: (context, animation,
                                    secondaryAnimation, child) {
                                  return FadeTransition(
                                      opacity: animation, child: child);
                                },
                              ),
                                  (route) => false,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.zero,
                            ),
                          ),
                          child: Text(
                            'Delete account',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhErrorRed),
                          ),
                        ),
                      ),
                    ],
                  ))
                : Scaffold(
                    appBar: AppBar(
                      title: const Text('Current order'),
                    ),
                    body: Column(
                      children: [
                        order.orderState == 'In Delivery'
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: MhMargins.mediumSmallMargin,
                                    horizontal: MhMargins.standardPadding),
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        final hasPermission =
                                            await LocationHandler
                                                .handleLocationPermission();
                                        if (hasPermission) {
                                          Navigator.of(context).push(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation, secondaryAnimation) =>
                                                  RiderLocationPage(
                                                    deliveryAddress:
                                                    LatLng(
                                                        order?.addressLat ?? 0,
                                                        order?.addressLong ?? 0),
                                                    orderId:
                                                    order?.id ?? '',
                                                  ),
                                              transitionsBuilder:
                                                  (context, animation, secondaryAnimation, child) {
                                                return FadeTransition(opacity: animation, child: child);
                                              },
                                            ),
                                          );
                                        }
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          const Icon(
                                            Icons.location_on,
                                            color: MhColors.mhPurple,
                                            size: 30,
                                          ),
                                          Text(
                                            'See map',
                                            style: MhTextStyle
                                                .heading4Style
                                                .copyWith(
                                                    color: MhColors.mhPurple),
                                          ),
                                        ],
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        'To: ${order.location}',
                                        style: MhTextStyle.heading4Style
                                            .copyWith(
                                                color: MhColors.mhBlueLight),
                                      ),
                                      subtitle: Text(
                                        'From: ${order.pharmacyName}',
                                        style: MhTextStyle.bodyRegularStyle
                                            .copyWith(color: MhColors.mhPurple),
                                      ),
                                    ),
                                    MhButton(
                                      text: 'Finish Delivery',
                                      onTap: () {
                                        if (order != null) {
                                          _finishDelivery(order);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await AuthenticationService().signOut();
                              Navigator.of(context).pushAndRemoveUntil(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 1.0),
                              shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.zero, // No border radius
                              ),
                            ),
                            child: Text(
                              'Sign out',
                              style: MhTextStyle.bodyRegularStyle
                                  .copyWith(color: MhColors.mhErrorRed),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await firebaseController.deletePrivateUser();
                              await AuthenticationService().deleteAccount();
                              Navigator.of(context).pushAndRemoveUntil(
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) =>
                                  const LoginPage(),
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    return FadeTransition(
                                        opacity: animation, child: child);
                                  },
                                ),
                                    (route) => false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(
                              'Delete account',
                              style: MhTextStyle.bodyRegularStyle
                                  .copyWith(color: MhColors.mhErrorRed),
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

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());

  Future<void> _finishDelivery(UserOrder order) async {
    final docOrders =
        FirebaseFirestore.instance.collection('Orders').doc(order.id);
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat('dd.MM.yyyy HH:mm');
    String formattedDate = formatter.format(now);
    await docOrders.update({
      'orderState': 'Delivered',
      'deliveryDate': formattedDate,
    });
  }
}
