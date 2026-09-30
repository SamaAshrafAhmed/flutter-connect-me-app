import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  FirebaseFirestore get firestore => _firestore;

  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection("users").doc(userId).set(data);
  }

  Future<Map<String, dynamic>?> getUser({required String userId}) async {
    final document = await _firestore.collection("users").doc(userId).get();
    if (!document.exists) {
      return null;
    }
    return document.data();
  }

  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> data,
  }) async {
    await _firestore.collection("users").doc(userId).update(data);
  }
}
