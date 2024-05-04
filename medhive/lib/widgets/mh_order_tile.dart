import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/pages/mh_pharmacy_details_page.dart';

import '../entities/medicine.dart';
import '../entities/pharmacy.dart';

class OrderTile extends StatelessWidget {
  final String id;
  final String pharmacyName;
  final String pharmacyLogo;
  final String deliveryDate;
  final String location;
  final List<dynamic> products;
  final List<dynamic> productQuantity;
  final double totalPrice;

  const OrderTile({
    super.key,
    required this.id,
    required this.pharmacyName,
    required this.pharmacyLogo,
    required this.deliveryDate,
    required this.location,
    required this.products,
    required this.productQuantity,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pharmacy>>(
        stream: _readPharmacies(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final pharmacies = snapshot.data!;
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(MhMargins.mhStandardBorderRadius),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: MhMargins.standardPadding,
                        top: MhMargins.standardPadding),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(MhMargins.standardPadding),
                        image: DecorationImage(
                          image: AssetImage(pharmacyLogo),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(MhMargins.standardPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pharmacyName,
                            style: MhTextStyle.heading4Style
                                .copyWith(color: MhColors.mhBlueRegular),
                          ),
                          Text(
                            'Order delivered in $deliveryDate at $location',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhBlueRegular),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: MhMargins.smallMargin),
                            child: SizedBox(
                              height: productQuantity.length == 1
                                  ? 24
                                  : productQuantity.length == 2
                                      ? 47
                                      : productQuantity.length >= 3
                                          ? 70
                                          : 0,
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: productQuantity.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    '${productQuantity[index].toString()} x ${products[index]}',
                                    style: MhTextStyle.bodyRegularStyle
                                        .copyWith(color: MhColors.mhPurple),
                                  );
                                },
                              ),
                            ),
                          ),
                          productQuantity.length > 3
                              ? Text(
                                  '+ ${productQuantity.length - 3} other products',
                                  style: MhTextStyle.bodyRegularStyle
                                      .copyWith(color: MhColors.mhPurple),
                                )
                              : const SizedBox(),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: MhMargins.smallMargin),
                            child: Divider(
                              thickness: 1,
                              color: MhColors.mhBlueLight,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '$totalPrice lei',
                                style: MhTextStyle.heading4Style
                                    .copyWith(color: MhColors.mhBlueRegular),
                              ),
                              InkWell(
                                onTap: () {
                                  Pharmacy pharmacy = pharmacies
                                      .where((element) =>
                                          element.name == pharmacyName)
                                      .first;
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => MhPharmacyDetails(
                                          pharmacy: pharmacy,
                                          hasSpecialOffer:
                                              _hasSpecialOffer(pharmacy))));
                                },
                                child: Text(
                                  'See partner',
                                  style: MhTextStyle.heading4Style
                                      .copyWith(color: MhColors.mhPurple),
                                ),
                              )
                            ],
                          ),
                        ],
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

  Stream<List<Pharmacy>> _readPharmacies() => FirebaseFirestore.instance
      .collection('Pharmacies')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Pharmacy.fromJson(doc.data())).toList());

  bool _hasSpecialOffer(Pharmacy pharmacy) {
    List<Medicine> medicines = pharmacy.medicines;
    for (int i = 0; i < medicines.length; i++) {
      if (medicines[i].price != medicines[i].priceBeforeDiscount) {
        return true;
      }
    }
    return false;
  }
}
