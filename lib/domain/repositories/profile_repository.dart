import '../entities/user.dart';

abstract class ProfileRepository {
  Future<UserEntity> updateProfileImage({
    required UserEntity user,
    required String imagePath,
  });
}
