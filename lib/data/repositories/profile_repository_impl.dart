import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../services/firestore_service.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreService _firestoreService;
  final FirebaseStorage _storage;

  ProfileRepositoryImpl(this._firestoreService, this._storage);

  @override
  Future<UserEntity> updateProfileImage({
    required UserEntity user,
    required String imagePath,
  }) async {
    final imageReference = _storage
        .ref()
        .child('profile_images')
        .child('${user.id}.jpg');
    await imageReference.putFile(File(imagePath));
    final imageUrl = await imageReference.getDownloadURL();

    await _firestoreService.updateUser(
      userId: user.id,
      data: {'profileImageUrl': imageUrl},
    );

    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      profileImageUrl: imageUrl,
    );
  }
}
