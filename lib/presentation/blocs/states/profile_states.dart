import 'package:connectme_app/domain/entities/user.dart';

abstract class ProfileState {}

class ProfileInitialState extends ProfileState {}

class ProfileLoadedState extends ProfileState {}

class ProfileLoadingState extends ProfileState {
  final UserEntity user;
  final String deviceModel;
  final String operatingSystem;

  new({
    required this.user,
    required this.deviceModel,
    required this.operatingSystem,
  });
}

class ProfileImageUploadingState extends ProfileState {
  final UserEntity user;
  final String deviceModel;
  final String operatingSystem;

  new({
    required this.user,
    required this.deviceModel,
    required this.operatingSystem,
  });
}

class ProfileErrorState extends ProfileState {
  final String message;

  new(this.message);
}
