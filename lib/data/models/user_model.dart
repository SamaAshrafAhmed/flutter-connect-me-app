import 'package:connectme_app/domain/entities/user.dart';

class UserModel extends UserEntity {
  new({
    required super.id,
    required super.fullName,
    required super.email,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }
}
