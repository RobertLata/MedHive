import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/medicine.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/widgets/mh_snackbar.dart';

import '../constants/mh_margins.dart';
import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';
import 'mh_button.dart';

class MhMedicineTile extends ConsumerWidget {
  final Medicine medicine;
  const MhMedicineTile({super.key, required this.medicine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(MhMargins.mhStandardBorderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.all(MhMargins.mediumSmallMargin),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    style: MhTextStyle.heading3Style
                        .copyWith(color: MhColors.mhBlueRegular),
                  ),
                  Text(
                    medicine.manufacturer,
                    style: MhTextStyle.heading4Style
                        .copyWith(color: MhColors.mhBlueLight),
                  ),
                  Text(
                    'dosage: ${medicine.dosage}',
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhPurple),
                  ),
                  Text(
                    'type: ${medicine.type}',
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhPurple),
                  ),
                  Text(
                    'expires in: ${medicine.expiryDate}',
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhPurple),
                  ),
                  medicine.needsPrescription
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.featured_play_list_outlined,
                              size: 22,
                              color: MhColors.mhPurple,
                            ),
                            const SizedBox(
                              width: MhMargins.extraSmallMargin,
                            ),
                            Container(
                              constraints: const BoxConstraints(maxWidth: 130),
                              child: Text(
                                'Needs medical prescription',
                                style: MhTextStyle.bodyRegularStyle
                                    .copyWith(color: MhColors.mhPurple),
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                  medicine.price != medicine.priceBeforeDiscount
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: MhMargins.mediumSmallMargin),
                          child: Container(
                            constraints: const BoxConstraints(maxWidth: 170),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Price: ",
                                  style: MhTextStyle.bodyRegularStyle
                                      .copyWith(color: MhColors.mhBlueDark),
                                ),
                                Text(
                                  "${medicine.priceBeforeDiscount} lei",
                                  style: MhTextStyle.bodyRegularStyle.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: MhColors.mhErrorRed),
                                ),
                                const SizedBox(
                                  width: MhMargins.extraSmallMargin,
                                ),
                                Text(
                                  "${medicine.price} lei",
                                  style: MhTextStyle.bodyRegularStyle
                                      .copyWith(color: MhColors.mhBlueDark),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: MhMargins.mhStandardPadding),
                          child: Text(
                            "Price: ${medicine.price} lei",
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhBlueDark),
                          ),
                        ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(MhMargins.standardPadding),
                    ),
                    padding: const EdgeInsets.all(MhMargins.standardPadding),
                    child: Image.asset(
                      medicine.image,
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: MhMargins.standardPadding),
                    child: MhButton(
                      text: 'Add to basket',
                      width: 150,
                      height: 50,
                      onTap: () {
                        if (ref
                            .read(medicineListProvider.notifier)
                            .checkIfMedicineIsFromSamePharmacy(medicine)) {
                          if(ref
                              .read(medicineListProvider.notifier)
                              .checkIfMedicineAlreadyExists(medicine) == false) {
                            ref
                                .read(medicineListProvider.notifier)
                                .addMedicineToList(medicine);
                            showMhSnackbar(context,
                                'Product added successfully. See your basket',
                                isError: false, onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => const TabDecider(
                                            initialIndex: 2,
                                          )),
                                          (route) => false);
                                  ref.read(tabIndexProvider.notifier).selectTab(2);
                                });
                          } else {
                            showMhSnackbar(context,
                                'This product is already in your basket');
                          }
                        } else {
                          showMhSnackbar(context,
                              'You can\'t add products from another pharmacy to your basket');
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
