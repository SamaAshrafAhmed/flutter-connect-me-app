import 'package:connectme_app/domain/entities/user.dart';
import 'package:connectme_app/domain/repositories/auth_repository.dart';
import 'package:connectme_app/presentation/blocs/states/auth_states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  new(this._authRepository) : super(AuthInitialState());

  void checkAuthStatus() {
    final UserEntity? user = _authRepository.getCurrentUser();
    if (user == null) {
      emit(AuthUnAuthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoadingState());
      final UserEntity user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoadingState());
      final user = await _authRepository.signUp(
        fullName: fullName,
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthError(_getErrorMessage(e)));
    }
  }
}

String _getErrorMessage(Object error) {
  if (error is FirebaseAuthException) {
    switch (error.code) {
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return 'The email or password is incorrect.';

      case 'email-already-in-use':
        return 'This email is already registered.';

      case 'invalid-email':
        return 'Please enter a valid email address.';

      case 'weak-password':
        return 'The password is too weak.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';

      case 'network-request-failed':
        return 'Please check your internet connection.';

      default:
        return 'Authentication failed. Please try again.';
    }
  }

  return 'Something went wrong. Please try again.';
}
