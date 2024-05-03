import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/pages/mh_pharmacy_details_page.dart';
import 'package:medhive/widgets/mh_pharmacy_tile.dart';

import '../entities/medicine.dart';
import '../entities/pharmacy.dart';

class PharmacyLists extends StatelessWidget {
  const PharmacyLists({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Pharmacy>>(
      stream: _readPharmacies(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final pharmacies = snapshot.data!;
          List<Pharmacy> pharmaciesWithDiscount =
              _getPharmaciesWithDiscount(pharmacies);
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: MhMargins.smallMargin,
                    horizontal: MhMargins.standardPadding),
                child: Text(
                  'Pharmacies: ',
                  style: MhTextStyle.heading4Style
                      .copyWith(color: MhColors.mhBlueRegular),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MhMargins.mediumSmallMargin),
                child: SizedBox(
                  height: 255,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: pharmacies.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MhMargins.mediumSmallMargin),
                        child: MhPharmacyTile(
                            pharmacy: pharmacies[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MhPharmacyDetails(
                                        pharmacy: pharmacies[index],
                                        hasSpecialOffer:
                                            _hasSpecialOffer(pharmacies[index]),
                                      )));
                            },
                            hasSpecialOffers:
                                _hasSpecialOffer(pharmacies[index])),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: MhMargins.standardPadding,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: MhMargins.smallMargin,
                    horizontal: MhMargins.standardPadding),
                child: Text(
                  'Discounts: ',
                  style: MhTextStyle.heading4Style
                      .copyWith(color: MhColors.mhBlueRegular),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MhMargins.mediumSmallMargin),
                child: SizedBox(
                  height: 255,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: pharmaciesWithDiscount.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: MhMargins.mediumSmallMargin),
                        child: MhPharmacyTile(
                            pharmacy: pharmaciesWithDiscount[index],
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MhPharmacyDetails(
                                        pharmacy: pharmaciesWithDiscount[index],
                                        hasSpecialOffer: true,
                                      )));
                            },
                            hasSpecialOffers: true),
                      );
                    },
                  ),
                ),
              ),
            ],
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
      },
    );
  }

  List<Pharmacy> _getPharmaciesWithDiscount(List<Pharmacy> pharmacies) {
    return pharmacies.where((pharmacy) => _hasSpecialOffer(pharmacy)).toList();
  }

  bool _hasSpecialOffer(Pharmacy pharmacy) {
    List<Medicine> medicines = pharmacy.medicines;
    for (int i = 0; i < medicines.length; i++) {
      if (medicines[i].price != medicines[i].priceBeforeDiscount) {
        return true;
      }
    }
    return false;
  }

  Stream<List<Pharmacy>> _readPharmacies() => FirebaseFirestore.instance
      .collection('Pharmacies')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Pharmacy.fromJson(doc.data())).toList());
}
