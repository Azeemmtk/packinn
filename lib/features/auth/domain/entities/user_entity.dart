import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final bool emailVerified;
  final String? name;
  final String? phone;
  final bool phoneVerified;
  final int? age;
  final String? address;
  final String role;
  final String? profileImageUrl;
  final double? walletBalance;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.emailVerified = false,
    this.name,
    this.phone,
    this.phoneVerified= false,
    this.age,
    this.address,
    this.role = 'user', // Default role for this app
    this.profileImageUrl,
    this.walletBalance,
  });

  @override
  List<Object?> get props => [
    uid,
    email,
    displayName,
    photoURL,
    emailVerified,
    name,
    phone,
    phoneVerified,
    age,
    address,
    role,
    profileImageUrl,
    walletBalance,
  ];

  UserEntity copyWith({
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    bool? emailVerified,
    String? name,
    String? phone,
    bool? phoneVerified,
    int? age,
    String? address,
    String? role,
    String? profileImageUrl,
    double? walletBalance,
  }) {
    return UserEntity(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      emailVerified: emailVerified ?? this.emailVerified,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      phoneVerified: phoneVerified ?? this.phoneVerified,
      age: age ?? this.age,
      address: address ?? this.address,
      role: role ?? this.role,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}
