import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:packinn/features/auth/domain/entities/user_entity.dart';

import '../model/user_model.dart';

abstract class AuthDataSource {
  Future<UserEntity?> googleSignIn();
  Future<void> signOut();
  Future<UserEntity?> checkAuthStatus();
}

class AuthRemoteDataSourceImpl implements AuthDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required GoogleSignIn googleSignIn,
  }) : _googleSignIn = googleSignIn;

  @override
  Future<UserEntity?> googleSignIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          name: user.displayName,
          phone: '',
          age: 0,
          address: '',
          role: 'user',
          profileImageUrl: '',
        );
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      print('AuthRemoteDataSource: Google Sign-In failed: $e');
      throw Exception('Google Sign-In failed: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } catch (e) {
      print('AuthRemoteDataSource: Sign out failed: $e');
      throw Exception('Sign out failed: $e');
    }
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    try {
      final user = firebaseAuth.currentUser;
      if (user != null) {
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          name: user.displayName,
          phone: '',
          age: 0,
          address: '',
          role: 'user',
          profileImageUrl: '',
        );
        return userModel.toEntity();
      }
      return null;
    } catch (e) {
      print('AuthRemoteDataSource: Check auth status failed: $e');
      throw Exception('Check auth status failed: $e');
    }
  }
}
