import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/pharmacy.dart';
import 'package:medhive/widgets/stars_widget.dart';

import '../constants/mh_margins.dart';
import 'custom_fade_in.dart';

class MhPharmacyTile extends StatelessWidget {
  final Pharmacy pharmacy;
  final bool hasSpecialOffers;
  const MhPharmacyTile(
      {super.key, required this.pharmacy, required this.hasSpecialOffers});

  @override
  Widget build(BuildContext context) {
    return FadeIn(
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
      child: InkWell(
        borderRadius: BorderRadius.circular(MhMargins.standardPadding),
        onTap: () {},
        child: SizedBox(
          width: 300,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        color: MhColors.mhLightCream,
                        borderRadius: BorderRadius.all(
                            Radius.circular(MhMargins.standardPadding))),
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(MhMargins.standardPadding),
                      child: CustomFadeIn(
                        duration: const Duration(milliseconds: 50),
                        placeholder: const AssetImage(
                            'assets/images/placeholder_image.png'),
                        height: 162,
                        width: 300,
                        child: AssetImage(
                          pharmacy.logo,
                        ) as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: MhMargins.smallMargin,
                    left: MhMargins.smallMargin,
                    child: hasSpecialOffers
                        ? _buildTag(
                            backgroundColor: MhColors.mhBlueLight,
                            icon: Icons.percent,
                            text: 'Special Offers',
                            textColor: MhColors.mhWhite,
                          )
                        : const SizedBox(),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MhMargins.mediumSmallMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(
                        top: MhMargins.smallMargin,
                        bottom: MhMargins.extraSmallMargin,
                      ),
                      child: Text(
                        pharmacy.name,
                        style: MhTextStyle.heading4Style
                            .copyWith(color: MhColors.mhBlueDark),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        StarsWidget(
                          rating: pharmacy.rating,
                          starSize: 16,
                          starColor: MhColors.mhPurple,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: MhMargins.extraSmallMargin),
                          child: Text(
                            '${pharmacy.reviewCount.toString()} Reviews',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhPurple),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.delivery_dining,
                          color: MhColors.mhBlueLight,
                          size: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: MhMargins.extraSmallMargin),
                          child: Text(
                            "${pharmacy.deliveryCost} lei",
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhBlueLight),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTag(
      {required Color backgroundColor,
      required Color textColor,
      required IconData icon,
      required String text}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(MhMargins.standardPadding),
        color: backgroundColor,
      ),
      child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: MhMargins.smallMargin,
              vertical: MhMargins.extraSmallMargin),
          child: Row(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: MhMargins.extraSmallMargin),
                child: Icon(
                  icon,
                  size: 16,
                  color: textColor,
                ),
              ),
              Text(
                text,
                style: MhTextStyle.bodyExtraSmallRegularStyle
                    .copyWith(color: textColor),
              )
            ],
          )),
    );
  }
}
