import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medhive/pages/shopping_cart_page.dart';

import '../constants/mh_colors.dart';
import 'account_page.dart';
import 'bottom_navigation_tabs.dart';
import 'discover_page.dart';
import 'home_page.dart';
import 'order_page.dart';

class TabDecider extends ConsumerStatefulWidget {
  const TabDecider({super.key});

  @override
  ConsumerState<TabDecider> createState() => _TabDeciderState();
}

class _TabDeciderState extends ConsumerState<TabDecider> {

  @override
  Widget build(BuildContext context) {
    return const DefaultTabController(
      initialIndex: 0,
      length: 5,
      child: Scaffold(
        backgroundColor: MhColors.mhLightGrey,
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            HomePage(),
            DiscoverPage(),
            ShoppingCartPage(),
            OrderPage(),
            AccountPage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationTabs(),
      ),
    );
  }
}

