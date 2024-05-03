import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/entities/pharmacy.dart';
import 'package:medhive/widgets/mh_medicine_tile.dart';
import '../constants/mh_margins.dart';
import '../constants/mh_style.dart';
import '../helpers/url_helper.dart';

class MhPharmacyDetails extends StatefulWidget {
  final Pharmacy pharmacy;
  final bool hasSpecialOffer;
  const MhPharmacyDetails(
      {super.key, required this.pharmacy, required this.hasSpecialOffer});

  @override
  State<MhPharmacyDetails> createState() => _MhPharmacyDetailsState();
}

class _MhPharmacyDetailsState extends State<MhPharmacyDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhColors.mhWhite,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset(
                widget.pharmacy.logo,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover, // Cover the width of the device
              ),
              Positioned(
                top: 45,
                left: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
              Positioned(
                top: 45,
                right: 20,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.info_outline, color: Colors.black),
                    onPressed: () {
                      _showPharmacyInfo(context);
                    },
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: MhMargins.standardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      '${widget.pharmacy.reviewCount} reviews',
                      style: MhTextStyle.bodySmallRegularStyle
                          .copyWith(color: MhColors.mhDarkGrey),
                    ),
                    Row(
                      children: [
                        Text(
                          widget.pharmacy.rating.toString(),
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: Colors.black),
                        ),
                        const Icon(
                          Icons.star,
                          color: Colors.blue,
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery cost',
                      style: MhTextStyle.bodySmallRegularStyle
                          .copyWith(color: MhColors.mhDarkGrey),
                    ),
                    Text(
                      "${widget.pharmacy.deliveryCost} lei",
                      style: MhTextStyle.bodyRegularStyle
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Delivery time',
                      style: MhTextStyle.bodySmallRegularStyle
                          .copyWith(color: MhColors.mhDarkGrey),
                    ),
                    Text(
                      widget.pharmacy.deliveryTime,
                      style: MhTextStyle.bodyRegularStyle
                          .copyWith(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
          widget.hasSpecialOffer
              ? Padding(
                  padding:
                      const EdgeInsets.only(left: MhMargins.standardPadding),
                  child: Container(
                    height: 40,
                    width: 180,
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(MhMargins.standardPadding),
                      color: MhColors.mhBlueLight,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              right: MhMargins.extraSmallMargin),
                          child: Icon(
                            Icons.percent,
                            size: 20,
                            color: MhColors.mhWhite,
                          ),
                        ),
                        Text(
                          'Special offers',
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhWhite),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox(),
          Padding(
            padding: const EdgeInsets.only(
                left: MhMargins.standardPadding,
                top: MhMargins.standardPadding),
            child: Text(
              'Medicines in stock',
              style: MhTextStyle.bodyRegularStyle
                  .copyWith(color: MhColors.mhBlueDark),
            ),
          ),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.pharmacy.medicines.length,
                itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: MhMargins.mediumSmallMargin,
                          horizontal: MhMargins.standardPadding),
                      child: MhMedicineTile(
                          medicine: widget.pharmacy.medicines[index]),
                    )),
          ),
        ],
      ),
    );
  }

  void _showPharmacyInfo(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SizedBox(
          height: 280,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: MhMargins.standardPadding,
                    bottom: MhMargins.mhStandardPadding),
                child: Center(
                    child: Text(
                  'Details',
                  style: MhTextStyle.heading3Style
                      .copyWith(color: MhColors.mhBlueDark),
                )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: MhMargins.standardPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.pharmacy.name,
                      style: MhTextStyle.heading4Style
                          .copyWith(color: MhColors.mhBlueLight),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: MhMargins.standardPadding),
                      child: Text(
                        'Address from where the orders are delivered:',
                        style: MhTextStyle.bodyRegularStyle
                            .copyWith(color: MhColors.mhPurple),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.pharmacy.address,
                          style: MhTextStyle.bodyRegularStyle
                              .copyWith(color: MhColors.mhPurple),
                        ),
                        ElevatedButton(
                          onPressed: () => openMap(widget.pharmacy.address),
                          child: Text(
                            'See on map',
                            style: MhTextStyle.bodyRegularStyle
                                .copyWith(color: MhColors.mhPurple),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> openMap(String address) async {
    await UrlHelper.launchURLBrowser(
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$address'));
  }
}
