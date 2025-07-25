import 'package:packinn/features/auth/domain/entities/user_entity.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? name;
  final String? phone;
  final int age;
  final String? address;
  final String role;
  final String? profileImageUrl;

  UserModel({
    required this.uid,
    this.email,
    this.name,
    this.phone,
    this.age = 0,
    this.address,
    this.role = 'user',
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      age: (json['age'] as int?) ?? 0,
      address: json['address'] as String?,
      role: (json['role'] as String?) ?? 'user',
      profileImageUrl: json['profileImageUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'phone': phone,
      'age': age,
      'address': address,
      'role': role,
      'profileImageUrl': profileImageUrl,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      name: name,
      phone: phone,
      age: age,
      address: address,
      role: role,
      profileImageUrl: profileImageUrl,
    );
  }
}
