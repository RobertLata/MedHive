import 'package:cloud_firestore/cloud_firestore.dart';

import '../entities/pair.dart';

class GenericFirestoreRepo {
  static final FirebaseFirestore _firestoreInstance =
      FirebaseFirestore.instance;

  static Future<T> getData<T>(String collectionPath,
      {List<Pair<String, String>>? fieldQueryPairList}) async {
    if (fieldQueryPairList != null) {
      Query<Object?> queryObject = _firestoreInstance
          .collection(collectionPath)
          .where(fieldQueryPairList[0].p1, isEqualTo: fieldQueryPairList[0].p2);
      fieldQueryPairList.removeAt(0);
      for (var pair in fieldQueryPairList) {
        queryObject = queryObject.where(pair.p1, isEqualTo: pair.p2);
      }
      final response = await queryObject.get();
      return response as T;
    } else {
      final response =
      await _firestoreInstance.collection(collectionPath).get();
      return response as T;
    }
  }

  static Future<T> getDataWhereIn<T>(
      String collectionPath, String field, List<String> queryList) async {
    final response = await _firestoreInstance
        .collection(collectionPath)
        .where(field, whereIn: queryList)
        .get();
    return response as T;
  }

  static Future<T> getDataFromSubCollection<T>(String collectionPath,
      String documentId, String subCollectionPath) async {
    final response = await _firestoreInstance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .get();
    return response as T;
  }

  static Future<T> getDataFromSubCollectionDocument<T>(
      String collectionPath,
      String documentId,
      String subCollectionPath,
      String subCollectionDocumentId) async {
    final response = await _firestoreInstance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .doc(subCollectionDocumentId)
        .get();
    return response as T;
  }

  static Future<T> getDataFromSubCollectionOrderBy<T>(
      String collectionPath,
      String documentId,
      String subCollectionPath,
      String orderByField,
      bool isDescendingOrder) async {
    final response = await _firestoreInstance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .orderBy(orderByField, descending: isDescendingOrder)
        .get();
    return response as T;
  }

  static Future<T> getDataByDocumentId<T>(
      String collectionPath, String id) async {
    final response =
    await _firestoreInstance.collection(collectionPath).doc(id).get();
    return response.data() as T;
  }

  static Future<bool> checkIfSubcollectionExists(
      String collectionPath, String id, String subCollectionPath) async {
    final response = await _firestoreInstance
        .collection(collectionPath)
        .doc(id)
        .collection(subCollectionPath)
        .limit(1)
        .get();
    return response.size > 0;
  }

  static Future<void> deleteData(String collectionPath, String path) async {
    await _firestoreInstance.collection(collectionPath).doc(path).delete();
  }

  static Future<void> addData(
      String collectionPath, Map<String, dynamic> jsonData,
      {String? documentId}) async {
    if (documentId != null) {
      await _firestoreInstance
          .collection(collectionPath)
          .doc(documentId)
          .set(jsonData);
    } else {
      await _firestoreInstance.collection(collectionPath).add(jsonData);
    }
  }

  static Future<void> addDataToSubCollection(
      String collectionPath,
      String? documentId,
      String subCollectionPath,
      Map<String, dynamic> jsonData,
      {String? subCollectionDocumentId}) async {
    final collectionReference = _firestoreInstance.collection(collectionPath);
    if (subCollectionDocumentId != null) {
      await collectionReference
          .doc(documentId)
          .collection(subCollectionPath)
          .doc(subCollectionDocumentId)
          .set(jsonData);
    } else {
      await collectionReference
          .doc(documentId)
          .collection(subCollectionPath)
          .add(jsonData);
    }
  }

  static Future<void> updateData(String collectionPath, String path,
      Map<String, dynamic> fieldsToUpdate) async {
    await _firestoreInstance
        .collection(collectionPath)
        .doc(path)
        .update(fieldsToUpdate);
  }

  static Future<void> updateDataFromSubCollection(
      String collectionPath,
      String? documentId,
      String subCollectionPath,
      String subCollectionDocumentId,
      Map<String, dynamic> jsonData,
      ) async {
    await _firestoreInstance
        .collection(collectionPath)
        .doc(documentId)
        .collection(subCollectionPath)
        .doc(subCollectionDocumentId)
        .update(jsonData);
  }
}
