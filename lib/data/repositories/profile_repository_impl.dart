import 'dart:convert';
import 'dart:io';

import '../../domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../../services/firestore_service.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirestoreService _firestoreService;

  ProfileRepositoryImpl(this._firestoreService);

  @override
  Future<UserEntity> updateProfileImage({
    required UserEntity user,
    required String imagePath,
  }) async {
    // Store a resized, compressed image as a data URI in the user's Firestore
    // document so the profile has no dependency on Firebase Storage.
    final imageBytes = await File(imagePath).readAsBytes();
    final imageDataUri = 'data:image/jpeg;base64,${base64Encode(imageBytes)}';

    await _firestoreService.updateUser(
      userId: user.id,
      data: {'profileImageUrl': imageDataUri},
    );

    return UserModel(
      id: user.id,
      fullName: user.fullName,
      email: user.email,
      profileImageUrl: imageDataUri,
    );
  }
}
