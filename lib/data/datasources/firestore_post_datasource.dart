import 'package:cloud_firestore/cloud_firestore.dart';

class FirestorePostDataSource {
  final FirebaseFirestore _firestore;

  new(this._firestore);

  Stream<QuerySnapshot<Map<String, dynamic>>> getPosts() {
    return _firestore
        .collection("posts")
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> createPost(Map<String, dynamic> data) async {
    final document = _firestore.collection('posts').doc();

    await document.set({...data, 'id': document.id});
  }
}
