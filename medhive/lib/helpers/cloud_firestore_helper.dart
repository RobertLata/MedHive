import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/authentication_service.dart';

class CloudFirestoreHelper {
  static Future<void> updatePrivateUserAvatar(
      String avatarPath) async {
    final collection = FirebaseFirestore.instance.collection('PrivateUsers');

    final docRef = collection.doc(AuthenticationService.currentUserId);

    await docRef.update({'profileImage': avatarPath});
  }
}