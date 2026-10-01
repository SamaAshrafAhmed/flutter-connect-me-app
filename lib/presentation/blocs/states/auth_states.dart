import 'package:connectme_app/domain/entities/user.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState;
class AuthLoadingState extends AuthState;

class AuthUnAuthenticated extends AuthState;

class AuthAuthenticated extends AuthState {
  final UserEntity user;

  new(this.user);
}

class AuthError extends AuthState {
  final String message;

  new(this.message);
}
