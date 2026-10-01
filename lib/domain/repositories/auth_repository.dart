import 'package:connectme_app/domain/entities/user.dart';

abstract class AuthRepository {
  Future<UserEntity> login({required String email, required String password});
  Future<UserEntity> signUp({
    required String fullName,
    required String email,
    required String password,
  });
  Future<void> logout();
  UserEntity? getCurrentUser();
}
