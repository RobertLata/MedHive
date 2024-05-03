import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_style.dart';

import '../constants/mh_margins.dart';
import '../controllers/medicine_list_controller.dart';
import '../entities/medicine.dart';

class MhMedicineBasketTile extends ConsumerStatefulWidget {
  final Medicine medicine;
  const MhMedicineBasketTile({super.key, required this.medicine});

  @override
  ConsumerState<MhMedicineBasketTile> createState() => _MedicineCardState();
}

class _MedicineCardState extends ConsumerState<MhMedicineBasketTile> {
  bool _didRemoveCard = false;
  //late double _medicinePrice = widget.medicine.price;
  @override
  Widget build(BuildContext context) {
    final medicineState = ref.watch(medicineListProvider);
    return _didRemoveCard || medicineState.getMedicineDose(widget.medicine) == 0
        ? const SizedBox()
        : Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MhMargins.smallMargin,
                vertical: MhMargins.extraSmallMargin),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(MhMargins.standardPadding),
                border: Border.all(
                  color: MhColors.mhBlueLight,
                  width: 1.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: MhMargins.smallMargin,
                    top: MhMargins.extraSmallMargin,
                    bottom: MhMargins.extraSmallMargin),
                child: Row(
                  children: [
                    Image.asset(
                      widget.medicine.image,
                      height: 80,
                      width: 80,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          child: Text(
                            widget.medicine.name,
                            style: MhTextStyle.bodyBoldStyle
                                .copyWith(color: MhColors.mhBlueDark),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            widget.medicine.manufacturer,
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhPurple),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              _didRemoveCard = true;
                            });
                            ref
                                .read(medicineListProvider.notifier)
                                .removeMedicineFromList(widget.medicine);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: MhMargins.mediumSmallMargin),
                            child: Text(
                              'Remove',
                              style: MhTextStyle.bodySmallRegularStyle
                                  .copyWith(color: MhColors.mhBlueLight),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                if (medicineState
                                        .getMedicineDose(widget.medicine) >
                                    0) {
                                  ref
                                      .read(medicineListProvider.notifier)
                                      .removeOneMedicineFromList(
                                          widget.medicine);
                                  //_medicinePrice -= widget.medicine.price;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: MhColors.mhBlueLight,
                                elevation: 0,
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Icon(
                                LineIcons.minus,
                                color: MhColors.mhBlueDark,
                              ),
                            ),
                            Text(
                              medicineState
                                  .getMedicineDose(widget.medicine)
                                  .toString(),
                              style: MhTextStyle.bodyRegularStyle
                                  .copyWith(color: MhColors.mhDarkGrey),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                ref
                                    .read(medicineListProvider.notifier)
                                    .addMedicineToList(widget.medicine);
                                //_medicinePrice += widget.medicine.price;
                                ref
                                    .read(medicineListProvider.notifier)
                                    .incrementMedicinePrice(
                                        widget.medicine.name,
                                        widget.medicine.price);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: MhColors.mhBlueLight,
                                elevation: 0,
                                padding: const EdgeInsets.all(0),
                              ),
                              child: const Icon(
                                LineIcons.plus,
                                color: MhColors.mhBlueDark,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          //'$_medicinePrice lei',
                          '${widget.medicine.price.toStringAsFixed(2)} lei',
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhBlueRegular),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
