import 'package:connectme_app/data/models/user_builder.dart';
import 'package:connectme_app/data/models/user_model.dart';
import 'package:connectme_app/domain/entities/user.dart';
import 'package:connectme_app/domain/repositories/auth_repository.dart';
import 'package:connectme_app/services/auth_service.dart';
import 'package:connectme_app/services/firestore_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _authService;
  final FirestoreService _firestoreService;
  new(this._authService, this._firestoreService);
  @override
  @override
  User? getCurrentUser() {
    final firebaseUser = _authService.currentUser;

    if (firebaseUser == null) {
      return null;
    }

    return UserBuilder()
        .setId(firebaseUser.uid)
        .setEmail(firebaseUser.email ?? '')
        .build();
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final credential = await _authService.login(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception("Login Failed!");
    } else {
      User user = UserBuilder()
          .setId(firebaseUser.uid)
          .setEmail(firebaseUser.email ?? email)
          .build();
      final userData = await _firestoreService.getUser(
        userId: firebaseUser.uid,
      );

      if (userData != null) {
        return UserModel.fromJson({...userData, 'id': firebaseUser.uid});
      }
      return user;
    }
  }

  @override
  Future<void> logout() async {
    await _authService.logout();
  }

  @override
  Future<User> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final credential = await _authService.signUp(
      email: email,
      password: password,
    );
    final firebaseUser = credential.user;
    if (firebaseUser == null) {
      throw Exception("Sign Up Failed!");
    } else {
      User user = UserBuilder()
          .setId(firebaseUser.uid)
          .setEmail(firebaseUser.email ?? email)
          .setFullName(fullName)
          .build();

      await _firestoreService.createUser(
        userId: user.id,
        data: UserModel(
          id: user.id,
          fullName: user.fullName,
          email: user.email,
          profileImageUrl: user.profileImageUrl,
        ).toJson(),
      );
      return user;
    }
  }
}
