import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/widgets/mh_snackbar.dart';

import '../constants/mh_margins.dart';
import '../controllers/medicine_list_controller.dart';
import '../entities/medicine.dart';

class MhMedicineBasketTile extends ConsumerStatefulWidget {
  final Medicine medicine;
  final bool noEditOption;

  const MhMedicineBasketTile(
      {super.key,
      required this.medicine,
      required this.noEditOption,
      });

  @override
  ConsumerState<MhMedicineBasketTile> createState() => _MedicineCardState();
}

class _MedicineCardState extends ConsumerState<MhMedicineBasketTile> {
  bool _didRemoveCard = false;
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
                          width: 110,
                          child: Text(
                            widget.medicine.name,
                            style: MhTextStyle.bodyBoldStyle
                                .copyWith(color: MhColors.mhBlueDark),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(
                          width: 110,
                          child: Text(
                            widget.medicine.manufacturer,
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhPurple),
                          ),
                        ),
                        Visibility(
                          visible: !widget.noEditOption,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _didRemoveCard = true;
                              });
                              ref
                                  .read(medicineListProvider.notifier)
                                  .removeMedicineFromList(widget.medicine);
                              if (widget.noEditOption) {
                                Navigator.pop(context);
                              }
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
                            Visibility(
                              visible: !widget.noEditOption,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (medicineState
                                          .getMedicineDose(widget.medicine) >
                                      0) {
                                    ref
                                        .read(medicineListProvider.notifier)
                                        .removeOneMedicineFromList(
                                            widget.medicine);
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
                            ),
                            Text(
                              medicineState
                                  .getMedicineDose(widget.medicine)
                                  .toString(),
                              style: MhTextStyle.bodyRegularStyle
                                  .copyWith(color: MhColors.mhDarkGrey),
                            ),
                            Visibility(
                              visible: !widget.noEditOption,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (medicineState.getMedicineDose(widget.medicine) > widget.medicine.quantity) {
                                    showMhSnackbar(context, 'There are no ${widget.medicine.name} left');
                                    return;
                                  }
                                  ref
                                      .read(medicineListProvider.notifier)
                                      .addMedicineToList(widget.medicine);
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
                            ),
                          ],
                        ),
                        Text(
                          '${(widget.medicine.price * medicineState.getMedicineDose(widget.medicine)).toStringAsFixed(2)} lei',
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
