import '../constants/mh_margins.dart';

bool isSmallScreen(double height) {
  return height < MhMargins.widgetHeightThreshold;
}