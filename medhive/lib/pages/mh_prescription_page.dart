import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';
import 'package:medhive/entities/pharmacy.dart';
import 'package:medhive/pages/mh_finish_order_page.dart';
import 'package:medhive/widgets/mh_button.dart';
import 'package:medhive/widgets/mh_medicine_basket_tile.dart';
import 'package:medhive/widgets/mh_snackbar.dart';

import '../entities/medicine.dart';
import '../entities/order.dart';

class MhPrescriptionPage extends StatefulWidget {
  final List<Medicine> medicineThatRequirePrescription;
  final UserOrder order;
  final Pharmacy pharmacy;
  final double totalPrice;
  final String orderId;
  const MhPrescriptionPage(
      {super.key,
      required this.medicineThatRequirePrescription,
      required this.order,
      required this.pharmacy,
      required this.totalPrice,
      required this.orderId});

  @override
  State<MhPrescriptionPage> createState() => _MhPrescriptionPageState();
}

class _MhPrescriptionPageState extends State<MhPrescriptionPage> {
  String scanResult = '';
  bool isPrescriptionValid = false;
  late StreamSubscription<DocumentSnapshot> orderSubscription;

  @override
  void initState() {
    super.initState();
    orderSubscription = FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.order.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var orderData = UserOrder.fromJson(snapshot.data()!);
        if (orderData.isPrescriptionValid != isPrescriptionValid) {
          setState(() {
            isPrescriptionValid = orderData.isPrescriptionValid ?? false;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    orderSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhColors.mhWhite,
      appBar: AppBar(
        title: const Text('Prescription Page'),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if (isPrescriptionValid == true) {
            Navigator.of(context).push(
              PageRouteBuilder(
                pageBuilder: (context, animation, secondaryAnimation) =>
                    MhFinishOrderPage(
                  totalPrice: widget.totalPrice,
                  pharmacy: widget.pharmacy,
                  orderId: widget.orderId,
                ),
                transitionsBuilder:
                    (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            );
          } else {
            _showProcessingDialog(context);
          }
        },
        child: Container(
          height: 70,
          width: double.infinity,
          color: MhColors.mhPurple,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(right: MhMargins.standardPadding),
                child: Text(
                  'Verify prescription',
                  style: MhTextStyle.bodyRegularStyle
                      .copyWith(color: MhColors.mhWhite),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text(
              'The following medicines require a medical prescription.',
              style: MhTextStyle.heading4Style
                  .copyWith(color: MhColors.mhBlueRegular),
            ),
          ),
          ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.medicineThatRequirePrescription.length,
              itemBuilder: (context, index) => MhMedicineBasketTile(
                    medicine: widget.medicineThatRequirePrescription[index],
                    noEditOption: true,
                  )),
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text(
              'In order to continue please choose a type of prescription and wait for the pharmacy staff to verify it.',
              style: MhTextStyle.bodyRegularStyle
                  .copyWith(color: MhColors.mhBlueLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MhMargins.standardPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MhButton(
                  text: 'Scan prescription',
                  width: 180,
                  onTap: () async {
                    await _scanPrescription();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: MhMargins.standardPadding),
                  child: Text(
                    'Or',
                    style: MhTextStyle.bodyRegularStyle
                        .copyWith(color: MhColors.mhBlueLight),
                  ),
                ),
                MhButton(
                  text: 'Attach prescription',
                  width: 180,
                  onTap: () async {
                    await _pickAndReadFile();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _scanPrescription() async {
    String scanResult;
    try {
      scanResult = await FlutterBarcodeScanner.scanBarcode(
          '#FF6666', 'Cancel', true, ScanMode.DEFAULT);
    } on PlatformException {
      scanResult = "Error when scanning the barcode";
    }

    if (scanResult != '' && scanResult != '-1') {
      await uploadScanResultToFirebase(scanResult, widget.order.id);
      showMhSnackbar(context, 'Prescription barcode scanned successfully',
          isError: false);
    }
  }

  Future<void> uploadScanResultToFirebase(
      String content, String fileName) async {
    Uint8List fileBytes = Uint8List.fromList(utf8.encode(content));

    await FirebaseStorage.instance
        .ref('${widget.pharmacy.name}/$fileName')
        .putData(fileBytes);
  }

  Future<void> _pickAndReadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      await FirebaseStorage.instance
          .ref('${widget.pharmacy.name}/${widget.order.id}')
          .putData(fileBytes!);
      showMhSnackbar(context, 'Prescription attached successfully',
          isError: false);
    }
  }

  void _showProcessingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Waiting',
            style: MhTextStyle.heading4Style.copyWith(color: MhColors.mhPurple),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Your order is being processed. This shouldn't take long.",
                style: MhTextStyle.bodyRegularStyle
                    .copyWith(color: MhColors.mhBlueLight),
              ),
              const SizedBox(height: MhMargins.standardPadding),
              const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

    orderSubscription = FirebaseFirestore.instance
        .collection('Orders')
        .doc(widget.order.id)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        var orderData = UserOrder.fromJson(snapshot.data()!);
        if (orderData.isPrescriptionValid != isPrescriptionValid) {
          setState(() {
            isPrescriptionValid = orderData.isPrescriptionValid ?? false;
          });
        }
        if (orderData.isPrescriptionValid == true) {
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  MhFinishOrderPage(
                totalPrice: widget.totalPrice,
                pharmacy: widget.pharmacy,
                orderId: widget.orderId,
              ),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      }
    });
  }
}
