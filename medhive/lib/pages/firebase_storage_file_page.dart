import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/helpers/url_helper.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:medhive/widgets/mh_order_tile.dart';

import '../constants/mh_colors.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../entities/order.dart';
import '../repositories/firebase_repository.dart';
import '../services/authentication_service.dart';
import 'login_page.dart';

class FirebaseStorageFilePage extends ConsumerStatefulWidget {
  const FirebaseStorageFilePage({super.key});

  @override
  ConsumerState<FirebaseStorageFilePage> createState() =>
      _FirebaseStorageFilePageState();
}

class _FirebaseStorageFilePageState
    extends ConsumerState<FirebaseStorageFilePage> {
  late Future<List<Map<String, dynamic>>> _fileList;

  @override
  void initState() {
    super.initState();
    _fileList = listFiles();
  }

  Future<List<Map<String, dynamic>>> listFiles() async {
    List<Map<String, dynamic>> files = [];
    String pharmacyName =
        AuthenticationService.currentUserEmail == 'health.harmony@gmail.com'
            ? 'Health Harmony'
            : '';

    final ListResult result =
        await FirebaseStorage.instance.ref(pharmacyName).listAll();

    for (var file in result.items) {
      String url = await file.getDownloadURL();
      files.add({
        "url": url,
        "name": file.name,
      });
    }

    return files;
  }

  @override
  Widget build(BuildContext context) {
    final firebaseController = ref.watch(firestoreRepositoryProvider);
    return StreamBuilder<List<UserOrder>>(
        stream: _readOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<UserOrder> orders = snapshot.data!;
            return Scaffold(
              backgroundColor: MhColors.mhWhite,
              appBar: AppBar(
                title: const Text("Uploaded Files"),
              ),
              body: Column(
                children: [
                  ...orders.map((order) => order.orderState == 'In Progress' ? Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: MhMargins.mediumSmallMargin,
                        horizontal: MhMargins.standardPadding),
                    child: OrderTile(id: order.id, pharmacyName: order.pharmacyName, pharmacyLogo: order.pharmacyLogo, deliveryDate: order.deliveryDate, location: order.location, products: order.products, productQuantity: order.productQuantity, totalPrice: order.totalPrice, deliveryState: order.orderState,),
                  ) : const SizedBox()),
                  FutureBuilder<List<Map<String, dynamic>>>(
                    future: _fileList,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        }

                        return Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(
                                        'Order: ${snapshot.data![index]["name"]}'),
                                    subtitle: InkWell(
                                        onTap: () {
                                          UrlHelper.launchURLBrowser(Uri.parse(
                                              snapshot.data![index]["url"]));
                                        },
                                        child:
                                            Text(snapshot.data![index]["url"])),
                                  ),
                                  MhButton(
                                    text: 'Approve',
                                    width: 180,
                                    onTap: () async {
                                      UserOrder orderToValidate = orders
                                          .where((element) =>
                                              element.id ==
                                              snapshot.data![index]["name"])
                                          .first;
                                      await _validateOrder(orderToValidate);
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
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

  Future<void> _validateOrder(UserOrder order) async {
    final docOrders =
        FirebaseFirestore.instance.collection('Orders').doc(order.id);

    await docOrders.update({
      'isPrescriptionValid': true,
    });
  }
}
