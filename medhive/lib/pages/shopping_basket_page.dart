import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/pages/tab_decider.dart';
import 'package:medhive/widgets/mh_appbar_logo_right.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:medhive/widgets/mh_medicine_basket_tile.dart';

import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';

class ShoppingBasketPage extends ConsumerWidget {
  const ShoppingBasketPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicineState = ref.watch(medicineListProvider);
    final medicinesWithNoDuplicates = medicineState.medicines.toSet().toList();
    return Scaffold(
      appBar: const MhAppBarLogoRight(),
      body: medicineState.medicines.isEmpty
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/empty_basket.png',
                  height: 300,
                  width: 300,
                ),
                Text(
                  'Your shopping basket is empty',
                  style: MhTextStyle.heading4Style
                      .copyWith(color: MhColors.mhBlueLight),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 60, horizontal: MhMargins.mhStandardPadding),
                  child: MhButton(
                    text: 'Start shopping',
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const TabDecider(
                                    initialIndex: 1,
                                  )),
                          (route) => false);
                      ref.read(tabIndexProvider.notifier).selectTab(1);
                    },
                  ),
                ),
              ],
            )
          : Column(
            children: [
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: medicinesWithNoDuplicates.length,
                  itemBuilder: (context, index) => MhMedicineBasketTile(
                      medicine: medicinesWithNoDuplicates[index]),
                ),
              ),
            ],
          ),
    );
  }
}
