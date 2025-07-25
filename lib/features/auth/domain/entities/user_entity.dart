import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? name;
  final String? phone;
  final int age;
  final String? address;
  final String role;
  final String? profileImageUrl;

  const UserEntity({
    required this.uid,
    this.email,
    this.name,
    this.phone,
    this.age = 0,
    this.address,
    this.role = 'user',
    this.profileImageUrl,
  });

  @override
  List<Object?> get props =>
      [uid, email, name, phone, age, address, role, profileImageUrl];
}
