import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/error/exceptions.dart';
import '../model/user_model.dart';
import 'user_remote_data_source.dart';

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final FirebaseFirestore firestore;

  UserRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await firestore
          .collection('users')
          .doc(user.uid)
          .set(user.toFirestore());
    } catch (e) {
      throw AuthException('Failed to save user to Firestore: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getUserFromFirestore(String uid) async {
    try {
      final doc = await firestore.collection('users').doc(uid).get();

      if (doc.exists) {
        return UserModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw AuthException('Failed to get user from Firestore: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> updateUserInFirestore(UserModel user) async {
    try {
      final updateData = user.toFirestore();
      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await firestore
          .collection('users')
          .doc(user.uid)
          .update(updateData);

      return user;
    } catch (e) {
      throw AuthException('Failed to update user in Firestore: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteUserFromFirestore(String uid) async {
    try {
      await firestore.collection('users').doc(uid).delete();
    } catch (e) {
      throw AuthException('Failed to delete user from Firestore: ${e.toString()}');
    }
  }
}
