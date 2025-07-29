import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoURL,
    super.emailVerified,
    super.name,
    super.phone,
    super.phoneVerified,
    super.age,
    super.address,
    super.role,
    super.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] ?? '',
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      emailVerified: json['emailVerified'] ?? false,
      name: json['name'],
      phone: json['phone'],
      phoneVerified: json['phoneVerified'] ?? false,
      age: json['age'],
      address: json['address'],
      role: json['role'] ?? 'user',
      profileImageUrl: json['profileImageUrl'],
    );
  }

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Document data is null');
    }

    return UserModel(
      uid: doc.id,
      email: data['email'],
      displayName: data['displayName'],
      photoURL: data['photoURL'],
      emailVerified: data['emailVerified'] ?? false,
      name: data['name'],
      phone: data['phone'],
      phoneVerified: data['phoneVerified'],
      age: data['age'],
      address: data['address'],
      role: data['role'] ?? 'user',
      profileImageUrl: data['profileImageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'emailVerified': emailVerified,
      'name': name,
      'phone': phone,
      'phoneVerified': phoneVerified,
      'age': age,
      'address': address,
      'role': role,
      'profileImageUrl': profileImageUrl,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }

  Map<String, dynamic> toFirestore() {
    final json = toJson();
    // Remove null values for Firestore
    json.removeWhere((key, value) => value == null);
    return json;
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      uid: entity.uid,
      email: entity.email,
      displayName: entity.displayName,
      photoURL: entity.photoURL,
      emailVerified: entity.emailVerified,
      name: entity.name,
      phone: entity.phone,
      phoneVerified: entity.phoneVerified,
      age: entity.age,
      address: entity.address,
      role: entity.role,
      profileImageUrl: entity.profileImageUrl,
    );
  }

  // Helper method to create user from Google Sign-In with empty additional fields
  factory UserModel.fromGoogleSignIn({
    required String uid,
    required String email,
    required String displayName,
    String? photoURL,
    bool emailVerified = true,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoURL: photoURL,
      emailVerified: emailVerified,
      name: null, // Empty - to be filled later
      phone: null, // Empty - to be filled later
      phoneVerified: false,
      age: null, // Empty - to be filled later
      address: null, // Empty - to be filled later
      role: 'user', // Default role for PackInn app
      profileImageUrl: photoURL, // Use Google photo as initial profile image
    );
  }
}
