
import '../model/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signUpWithEmail(String name, String email, String phone, String password);
  Future<UserModel> signInWithEmail(String email, String password);
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
  Future<bool> isUserSignedIn();
  Future<void> sendPasswordResetEmail(String email);

  // Add these missing Firestore methods
  Future<void> saveUserToFirestore(UserModel user);
  Future<UserModel?> getUserFromFirestore(String uid);
  Future<UserModel> updateUserInFirestore(UserModel user);

  Future<String> sendOtp(String phoneNumber);
  Future<UserModel> verifyOtp(String verificationId, String otp);
}
