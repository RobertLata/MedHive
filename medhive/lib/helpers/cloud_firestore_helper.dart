import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/credit_card.dart';
import '../services/authentication_service.dart';

class CloudFirestoreHelper {
  static Future<void> updatePrivateUserAvatar(
      String avatarPath) async {
    final collection = FirebaseFirestore.instance.collection('PrivateUsers');

    final docRef = collection.doc(AuthenticationService.currentUserId);

    await docRef.update({'profileImage': avatarPath});
  }

  static Future<void> updatePrimaryCreditCard(CreditCard creditCard) async {
    final collection = FirebaseFirestore.instance.collection('CreditCards');

    final selectedDocRef = collection.doc(creditCard.id);
    final docSnapshot = await selectedDocRef.get();

    if (!docSnapshot.exists) {
      return;
    }

    final batch = FirebaseFirestore.instance.batch();
    batch.update(selectedDocRef, {'isPrimary': true});

    final querySnapshot = await collection
        .where('userId', isEqualTo: creditCard.userId)
        .where('isPrimary', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      if (doc.id != creditCard.id) {
        batch.update(collection.doc(doc.id), {'isPrimary': false});
      }
    }

    await batch.commit();
  }
}