import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_style.dart';

import '../constants/mh_margins.dart';
import '../constants/string_constants.dart';
import '../controllers/medicine_list_controller.dart';
import '../controllers/tab_controller.dart';


class BottomNavigationTabs extends ConsumerStatefulWidget {
  const BottomNavigationTabs({
    super.key,
  });

  @override
  ConsumerState<BottomNavigationTabs> createState() =>
      _BottomNavigationTabsState();
}

class _BottomNavigationTabsState extends ConsumerState<BottomNavigationTabs> {
  @override
  Widget build(BuildContext context) {
    final tabState = ref.watch(tabIndexProvider);
    //final medicineState = ref.watch(medicineListProvider);
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: MhMargins.smallMargin,
              vertical: MhMargins.mediumMargin),
          child: GNav(
            rippleColor: MhColors.mhBlueLight,
            hoverColor: MhColors.mhBlueLight,
            gap: MhMargins.extraSmallMargin,
            activeColor: MhColors.mhWhite,
            iconSize: MhMargins.iconsSize,
            padding: const EdgeInsets.symmetric(
                horizontal: MhMargins.smallMargin,
                vertical: MhMargins.smallMargin),
            duration: const Duration(milliseconds: 400),
            tabBackgroundColor: MhColors.mhBlueLight,
            color: MhColors.mhDarkGrey,
            textStyle: MhTextStyle.bottomNavBarText
                .copyWith(color: MhColors.mhWhite),
            tabs: [
              const GButton(
                icon: LineIcons.home,
                text: HOME_TEXT,
              ),
              const GButton(
                icon: LineIcons.search,
                text: DISCOVER_TEXT,
              ),
              GButton(
                icon: LineIcons.shoppingCart,
                text: SHOPPING_CART,
                // leading: medicineState.medicines.isEmpty
                //     ? null
                //     : Badge(
                //   backgroundColor: MhColors.mhBlueDark,
                //   label: Text(
                //     medicineState.medicines.length.toString(),
                //     style: const TextStyle(color: MhColors.mhBlueLight),
                //   ),
                //   child: const Icon(
                //     LineIcons.shoppingCart,
                //     size: MhMargins.iconsSize,
                //   ),
                // ),
              ),
              const GButton(
                icon: LineIcons.list,
                text: ORDERS_TEXT,
              ),
              const GButton(
                icon: LineIcons.user,
                text: ACCOUNT_TEXT,
              ),
            ],
            selectedIndex: tabState,
            onTabChange: (index) {
              DefaultTabController.of(context).animateTo(index);
              ref.read(tabIndexProvider.notifier).selectTab(index);
            },
          ),
        ),
      ),
    );
  }
}
