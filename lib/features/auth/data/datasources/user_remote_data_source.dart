import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> saveUserProfile(UserModel user);
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> saveUserProfile(UserModel user) async {
    try {
      print('UserRemoteDataSource: Saving user profile for UID ${user.uid}');
      await firestore.collection('users').doc(user.uid).set(user.toJson());
      print('UserRemoteDataSource: User profile saved successfully');
    } catch (e) {
      print('UserRemoteDataSource: Failed to save user profile: $e');
      throw Exception('Failed to save user profile: $e');
    }
  }
}
