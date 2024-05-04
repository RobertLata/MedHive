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
import 'package:medhive/widgets/mh_button.dart';
import 'package:medhive/widgets/mh_medicine_basket_tile.dart';

import '../entities/medicine.dart';
import '../entities/order.dart';

class MhPrescriptionPage extends StatefulWidget {
  final List<Medicine> medicineThatRequirePrescription;
  final UserOrder order;
  const MhPrescriptionPage(
      {super.key, required this.medicineThatRequirePrescription, required this.order});

  @override
  State<MhPrescriptionPage> createState() => _MhPrescriptionPageState();
}

class _MhPrescriptionPageState extends State<MhPrescriptionPage> {
  String scanResult = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MhColors.mhWhite,
      appBar: AppBar(
        title: const Text('Prescription Page'),
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
                  medicine: widget.medicineThatRequirePrescription[index], isFromPrescriptionPage: true,)),
          Padding(
            padding: const EdgeInsets.all(MhMargins.standardPadding),
            child: Text(
              'In order to continue please enter the type of prescription and wait for the pharmacy staff to verify it.\nThe waiting shouldn\'t be long.',
              style: MhTextStyle.bodyRegularStyle
                  .copyWith(color: MhColors.mhBlueLight),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: MhMargins.standardPadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                MhButton(
                  text: 'Scan prescription',
                  width: 180,
                  onTap: () async {
                    await _scanPrescription();
                  },
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
    }
  }

  Future<void> uploadScanResultToFirebase(
      String content, String fileName) async {
    Uint8List fileBytes = Uint8List.fromList(utf8.encode(content));

    await FirebaseStorage.instance.ref('uploads/$fileName').putData(fileBytes);
  }

  Future<void> _pickAndReadFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(withData: true);

    if (result != null) {
      Uint8List? fileBytes = result.files.first.bytes;

      await FirebaseStorage.instance
          .ref('uploads/${widget.order.id}')
          .putData(fileBytes!);
    }
  }

  Stream<List<UserOrder>> _readOrders() => FirebaseFirestore.instance
      .collection('Orders')
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) => UserOrder.fromJson(doc.data())).toList());
}
