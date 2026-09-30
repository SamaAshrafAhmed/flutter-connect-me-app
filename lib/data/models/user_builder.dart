import 'user_model.dart';

class UserBuilder {
  String? _id;
  String? _fullName;
  String? _email;
  String? _profileImageUrl;

  UserBuilder setId(String id) {
    _id = id;
    return this;
  }

  UserBuilder setFullName(String fullName) {
    _fullName = fullName;
    return this;
  }

  UserBuilder setEmail(String email) {
    _email = email;
    return this;
  }

  UserBuilder setProfileImageUrl(String? profileImageUrl) {
    _profileImageUrl = profileImageUrl;
    return this;
  }

  UserModel build() {
    return UserModel(
      id: _id ?? '',
      fullName: _fullName ?? '',
      email: _email ?? '',
      profileImageUrl: _profileImageUrl,
    );
  }
}
