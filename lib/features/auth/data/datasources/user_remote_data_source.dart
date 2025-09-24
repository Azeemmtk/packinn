
import '../../../../core/model/user_model.dart';

abstract class UserRemoteDataSource {
  Future<void> saveUserToFirestore(UserModel user);
  Future<UserModel?> getUserFromFirestore(String uid);
  Future<UserModel> updateUserInFirestore(UserModel user);
  Future<void> deleteUserFromFirestore(String uid);
}
