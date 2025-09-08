import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:packinn/core/error/exceptions.dart';

import '../../../../../auth/data/model/user_model.dart';

abstract class UserProfileRemoteDataSource {
  Future<UserModel> getUser(String uid);
  Future<void> updateUser(UserModel user);
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  UserProfileRemoteDataSourceImpl({required this.firestore});

  @override
  Future<UserModel> getUser(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();
      if (!doc.exists) {
        throw ServerException('User not found');
      }
      return UserModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateUser(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.uid).update(user.toFirestore());
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}