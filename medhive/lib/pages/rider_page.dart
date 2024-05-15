import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/rider_location_page.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:latlong2/latlong.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_style.dart';
import '../entities/order.dart';
import '../repositories/firebase_repository.dart';
import '../services/authentication_service.dart';
import 'login_page.dart';

class RiderPage extends ConsumerWidget {
  const RiderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseController = ref.watch(firestoreRepositoryProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rider Page'
        ),
      ),
      body: Column(
        children: [
          MhButton(text: 'Open map', onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(
                builder: (context) => MapPage(
                  deliveryAddress: LatLng(
                      45.7409, 21.2007),
                )));
          },),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await AuthenticationService().signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const LoginPage()),
                      (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 1.0),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero, // No border radius
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
                    MaterialPageRoute(
                        builder: (context) => const LoginPage()),
                        (route) => false);
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
  }

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());
}
