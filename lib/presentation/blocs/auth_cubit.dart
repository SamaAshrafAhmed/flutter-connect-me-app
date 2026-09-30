import 'package:connectme_app/domain/entities/user.dart';
import 'package:connectme_app/domain/repositories/auth_repository.dart';
import 'package:connectme_app/presentation/blocs/states/auth_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;
  new(this._authRepository) : super(AuthInitialState());

  void checkAuthStatus() {
    final User? user = _authRepository.getCurrentUser();
    if (user == null) {
      emit(AuthUnAuthenticated());
    } else {
      emit(AuthAuthenticated(user));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      emit(AuthLoadingState());
      final User user = await _authRepository.login(
        email: email,
        password: password,
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
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
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    try {
      await _authRepository.logout();
      emit(AuthUnAuthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
