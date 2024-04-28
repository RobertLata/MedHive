import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';

class OrderTile extends StatelessWidget {
  final String id;
  final String pharmacyName;
  final String pharmacyLogo;
  final String deliveryDate;
  final String location;
  final List<dynamic> products;
  final List<dynamic> productQuantity;
  final double totalPrice;
  final VoidCallback onTap;

  const OrderTile({
    super.key,
    required this.id,
    required this.pharmacyName,
    required this.pharmacyLogo,
    required this.deliveryDate,
    required this.location,
    required this.products,
    required this.productQuantity,
    required this.totalPrice,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(MhMargins.mhStandardBorderRadius),
        side: const BorderSide(color: MhColors.mhBlueLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: MhMargins.standardPadding,
                top: MhMargins.standardPadding),
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(MhMargins.standardPadding),
                image: DecorationImage(
                  image: AssetImage(pharmacyLogo),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(MhMargins.standardPadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pharmacyName,
                    style: MhTextStyle.heading4Style
                        .copyWith(color: MhColors.mhBlueRegular),
                  ),
                  Text(
                    'Order delivered in $deliveryDate at $location',
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhBlueRegular),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: MhMargins.smallMargin),
                    child: SizedBox(
                      height: productQuantity.length == 1 ? 24 : productQuantity.length == 2 ? 47 : productQuantity.length >= 3 ? 70 : 0,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: productQuantity.length,
                        itemBuilder: (context, index) {
                          return Text(
                            '${productQuantity[index].toString()} x ${products[index]}',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhPurple),
                          );
                        },
                      ),
                    ),
                  ),
                  productQuantity.length > 3
                      ? Text(
                          '+ ${productQuantity.length - 3} other products',
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhPurple),
                        )
                      : const SizedBox(),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: MhMargins.smallMargin),
                    child: Divider(
                      thickness: 1,
                      color: MhColors.mhBlueLight,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '$totalPrice lei',
                        style: MhTextStyle.heading4Style
                            .copyWith(color: MhColors.mhBlueRegular),
                      ),
                      InkWell(
                        onTap: onTap,
                        child: Text(
                          'See partner',
                          style: MhTextStyle.heading4Style
                              .copyWith(color: MhColors.mhPurple),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
