import 'package:flutter_riverpod/flutter_riverpod.dart';

final tabIndexProvider = StateNotifierProvider<TabIndex, int>((ref) {
  return TabIndex();
});

class TabIndex extends StateNotifier<int> {
  TabIndex() : super(0);
  void selectTab(int index) => state = index;
}