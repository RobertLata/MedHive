import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/private_user.dart';
import '../helpers/image_clarity_helper.dart';
import 'generic_firebase_repository.dart';

class FirestoreRepository {
  const FirestoreRepository({required this.genericFirestoreRepo});

  final GenericFirestoreRepo genericFirestoreRepo;

  Future<void> addPrivateUser(String? userName) async {
    final FirebaseAuth authInstance = FirebaseAuth.instance;
    String? photoUrl = authInstance.currentUser!.photoURL;

    if (photoUrl?.contains('lh3.googleusercontent') ?? false) {
      photoUrl = increaseImageQualityOfGoogleImage(photoUrl!);
    }

    final privateUser = PrivateUser(
      id: authInstance.currentUser!.uid,
      email: authInstance.currentUser!.email,
      name: authInstance.currentUser!.displayName,
      profileImage: photoUrl,
      username: userName,
    );

    final jsonPrivateUser = privateUser.toJson();

    await GenericFirestoreRepo.addData(
        "PrivateUsers", jsonPrivateUser,
        documentId: authInstance.currentUser!.uid);

    return;
  }

  Future<PrivateUser?> readPrivateUser(String? userId) async {
    if (userId != null && userId.isNotEmpty) {
      final userDoc = FirebaseFirestore.instance
          .collection("PrivateUsers")
          .doc(userId);
      final snapshot = await userDoc.get();

      if (snapshot.exists) {
        return PrivateUser.fromJson(snapshot.data()!);
      }
    }
    return null;
  }

  Future<void> deletePrivateUser() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    await GenericFirestoreRepo.deleteData("PrivateUsers", userId);
  }
}

final firestoreRepositoryProvider = Provider.autoDispose((ref) {
  return FirestoreRepository(genericFirestoreRepo: GenericFirestoreRepo());
});
