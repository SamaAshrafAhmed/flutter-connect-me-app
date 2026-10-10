import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../injection.dart';
import '../blocs/profile_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..loadProfile(),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProfileError) {
            return Center(child: Text(state.message));
          }

          if (state is ProfileImageUploading) {
            return _buildProfile(
              context,
              state.user,
              state.deviceModel,
              state.operatingSystem,
              isUploading: true,
            );
          }

          if (state is ProfileLoaded) {
            return _buildProfile(
              context,
              state.user,
              state.deviceModel,
              state.operatingSystem,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    user,
    String deviceModel,
    String operatingSystem, {
    bool isUploading = false,
  }) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final profileImage = _profileImage(user.profileImageUrl);

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: profileImage,
                child:
                    user.profileImageUrl == null ||
                        user.profileImageUrl!.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),

              if (isUploading)
                const Positioned.fill(
                  child: CircleAvatar(
                    backgroundColor: Colors.black45,
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 20),

          Text(
            user.fullName,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          Text(user.email),

          const SizedBox(height: 30),

          ListTile(
            leading: const Icon(Icons.phone_android),
            title: const Text('Device'),
            subtitle: Text(deviceModel),
          ),

          ListTile(
            leading: const Icon(Icons.system_update),
            title: const Text('Operating System'),
            subtitle: Text(operatingSystem),
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isUploading ? null : () => _showImageOptions(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text('Update Profile Photo'),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider<Object>? _profileImage(String? imageValue) {
    if (imageValue == null || imageValue.isEmpty) {
      return null;
    }

    if (imageValue.startsWith('data:image/')) {
      final encodedImage = imageValue.substring(imageValue.indexOf(',') + 1);
      return MemoryImage(base64Decode(encodedImage));
    }

    return NetworkImage(imageValue);
  }

  void _showImageOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (sheetContext) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(sheetContext);

                  context.read<ProfileCubit>().pickProfileImage(
                    ImageSource.camera,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () {
                  Navigator.pop(sheetContext);

                  context.read<ProfileCubit>().pickProfileImage(
                    ImageSource.gallery,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
