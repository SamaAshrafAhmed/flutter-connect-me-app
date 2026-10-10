import '../entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileImage {
  final ProfileRepository _repository;

  UpdateProfileImage(this._repository);

  Future<UserEntity> call({
    required UserEntity user,
    required String imagePath,
  }) async {
    return await _repository.updateProfileImage(
      user: user,
      imagePath: imagePath,
    );
  }
}
