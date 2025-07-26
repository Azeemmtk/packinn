
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> signUpWithEmailPassword(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isUserSignedIn();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> verifyOTP(String otp);

  // Add these missing Firestore methods
  Future<void> saveUserToFirestore(UserModel user);
  Future<UserModel?> getUserFromFirestore(String uid);
  Future<UserModel> updateUserInFirestore(UserModel user);
}
