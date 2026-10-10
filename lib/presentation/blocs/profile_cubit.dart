import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/get_profile.dart';
import '../../domain/usecases/update_profile_image.dart';
import '../../services/device_info_service.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserEntity user;
  final String deviceModel;
  final String operatingSystem;

  ProfileLoaded({
    required this.user,
    required this.deviceModel,
    required this.operatingSystem,
  });
}

class ProfileImageUploading extends ProfileState {
  final UserEntity user;
  final String deviceModel;
  final String operatingSystem;

  ProfileImageUploading({
    required this.user,
    required this.deviceModel,
    required this.operatingSystem,
  });
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfile _getProfile;
  final UpdateProfileImage _updateProfileImage;
  final DeviceInfoService _deviceInfoService;

  final ImagePicker _imagePicker = ImagePicker();

  ProfileCubit(
    this._getProfile,
    this._updateProfileImage,
    this._deviceInfoService,
  ) : super(ProfileInitial());

  Future<void> loadProfile() async {
    try {
      emit(ProfileLoading());

      final user = await _getProfile();

      if (user == null) {
        emit(ProfileError('Unable to load your profile.'));
        return;
      }

      final deviceModel = await _deviceInfoService.getDeviceModel();

      final operatingSystem = await _deviceInfoService.getOperatingSystem();

      emit(
        ProfileLoaded(
          user: user,
          deviceModel: deviceModel,
          operatingSystem: operatingSystem,
        ),
      );
    } catch (e) {
      emit(ProfileError('Unable to load your profile. Please try again.'));
    }
  }

  Future<void> pickProfileImage(ImageSource source) async {
    final currentState = state;

    if (currentState is! ProfileLoaded) {
      return;
    }

    try {
      final image = await _imagePicker.pickImage(
        source: source,
        imageQuality: 80,
        maxWidth: 600,
        maxHeight: 600,
      );

      if (image == null) {
        return;
      }

      emit(
        ProfileImageUploading(
          user: currentState.user,
          deviceModel: currentState.deviceModel,
          operatingSystem: currentState.operatingSystem,
        ),
      );

      final updatedUser = await _updateProfileImage(
        user: currentState.user,
        imagePath: image.path,
      );

      emit(
        ProfileLoaded(
          user: updatedUser,
          deviceModel: currentState.deviceModel,
          operatingSystem: currentState.operatingSystem,
        ),
      );
    } catch (e) {
      emit(ProfileError('Unable to update your profile image.'));
    }
  }
}
