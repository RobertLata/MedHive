import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medhive/constants/mh_colors.dart';
import 'package:medhive/constants/mh_margins.dart';
import 'package:medhive/constants/mh_style.dart';

import '../entities/address.dart';
import '../services/authentication_service.dart';
import '../widgets/mh_address_tile.dart';

class SetupLocationPage extends StatefulWidget {
  final Function()? onAddressChanged;
  const SetupLocationPage({super.key, this.onAddressChanged});

  @override
  State<SetupLocationPage> createState() => _SetupLocationPageState();
}

class _SetupLocationPageState extends State<SetupLocationPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Address>>(
      stream: _readAddresses(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final addresses = snapshot.data!.where((element) =>
              element.userId == AuthenticationService.currentUserId);
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Delivery Location',
                style: MhTextStyle.heading4Style,
              ),
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  leading: const Icon(Icons.add, color: MhColors.mhBlueLight),
                  title: const Text(
                    'Add new address',
                    style: MhTextStyle.bodyRegularStyle,
                  ),
                  trailing: const Icon(Icons.chevron_right,
                      color: MhColors.mhBlueDark),
                  onTap: () {
                    _showAddAddressDialog(context);
                  },
                ),
                Padding(
                  padding: const EdgeInsets.all(MhMargins.standardPadding),
                  child: addresses.isNotEmpty
                      ? const Text(
                          "Your saved addresses:",
                          style: MhTextStyle.bodyRegularStyle,
                        )
                      : null,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: MhMargins.smallMargin),
                    child: ListView(
                      children: addresses.map(buildAddress).toList(),
                    ),
                  ),
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Scaffold(body: Center(child: Text("Error")));
        } else {
          return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(
              color: MhColors.mhBlueDark,
            )),
          );
        }
      },
    );
  }

  Future<void> _showAddAddressDialog(BuildContext context) async {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    String? addressName;
    String? addressStreet;
    String? addressLocation;

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add new address',
            style: MhTextStyle.heading4Style,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Address nickname',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an Address nickname';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          addressName = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Street',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address street';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          addressStreet = value;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'City',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the address city';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          addressLocation = value;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: MhTextStyle.bodyRegularStyle,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Save',
                style: MhTextStyle.bodyRegularStyle,
              ),
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  formKey.currentState!.save();
                  final String docId = generateRandomDocumentId();

                  final address = Address(
                      id: docId,
                      name: addressName!,
                      street: addressStreet!,
                      location: addressLocation!,
                      isPrimary: false,
                      userId: AuthenticationService.currentUser!.uid);

                  await _createAddress(address: address);

                  await _updatePrimaryAddress(address);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  String generateRandomDocumentId() {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('Addresses');

    DocumentReference newDocRef = collection.doc();

    String newDocId = newDocRef.id;

    return newDocId;
  }

  Future<void> _createAddress({required Address address}) async {
    final docAddress =
        FirebaseFirestore.instance.collection('Addresses').doc(address.id);

    final addressJson = address.toJson();
    await docAddress.set(addressJson);
  }

  Stream<List<Address>> _readAddresses() => FirebaseFirestore.instance
      .collection('Addresses')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => Address.fromJson(doc.data())).toList());

  Widget buildAddress(Address address) => AddressTile(
        addressName: address.name,
        addressStreet: address.street,
        addressLocation: address.location,
        isPrimary: address.isPrimary,
        onTap: () => {_updatePrimaryAddress(address)},
        onCloseTap: () => {_deleteAddress(address)},
      );

  Future<void> _updatePrimaryAddress(Address address) async {
    final collection = FirebaseFirestore.instance.collection('Addresses');

    final selectedDocRef = collection.doc(address.id);
    final docSnapshot = await selectedDocRef.get();

    if (!docSnapshot.exists) {
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    batch.update(selectedDocRef, {'isPrimary': true});

    final querySnapshot = await collection
        .where('userId', isEqualTo: address.userId)
        .where('isPrimary', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != address.id) {
        batch.update(collection.doc(doc.id), {'isPrimary': false});
      }
    }

    await batch.commit();
    await _updatePrivateUserAddress(address.street, address.location);
  }

  Future<void> _deleteAddress(Address address) async {
    final collection = FirebaseFirestore.instance.collection('Addresses');

    final docRef = collection.doc(address.id);

    await docRef.delete();
  }

  Future<void> _updatePrivateUserAddress(
      String addressLocation, String addressCity) async {
    final collection = FirebaseFirestore.instance.collection('PrivateUsers');

    final docRef = collection.doc(AuthenticationService.currentUserId);

    await docRef.update({'selectedAddress': "$addressLocation, $addressCity"});
    widget.onAddressChanged?.call();
  }
}
