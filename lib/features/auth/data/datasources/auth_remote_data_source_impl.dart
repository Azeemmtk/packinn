import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../model/user_model.dart';
import 'auth_remote_data_source.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final GoogleSignIn googleSignIn;
  final FirebaseFirestore firestore;

  AuthRemoteDataSourceImpl({
    required this.firebaseAuth,
    required this.googleSignIn,
    required this.firestore,
  });

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        throw const AuthException('Google sign-in was cancelled');
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw const AuthException('Failed to sign in with Google');
      }

      // Create user model from Google Sign-In
      final userModel = UserModel.fromGoogleSignIn(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName ?? '',
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
      );

      // Check if user exists in Firestore
      final existingUser = await getUserFromFirestore(user.uid);

      if (existingUser == null) {
        // New user - save to Firestore with empty additional fields
        await saveUserToFirestore(userModel);
        return userModel;
      } else {
        // Existing user - return from Firestore (has complete profile)
        return existingUser;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign-in failed');
    } catch (e) {
      throw AuthException('Unexpected error during Google sign-in: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw const AuthException('Failed to sign in with email and password');
      }

      // Get user from Firestore
      final userFromFirestore = await getUserFromFirestore(user.uid);

      if (userFromFirestore != null) {
        return userFromFirestore;
      } else {
        // If not in Firestore, create and save
        final userModel = UserModel(
          uid: user.uid,
          email: user.email,
          displayName: user.displayName,
          photoURL: user.photoURL,
          emailVerified: user.emailVerified,
          role: 'user',
        );
        await saveUserToFirestore(userModel);
        return userModel;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Unexpected error during sign-in: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user == null) {
        throw const AuthException('Failed to create user account');
      }

      // Create user model with empty additional fields
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
        role: 'user', // Set role as 'user' for PackInn app
      );

      // Save to Firestore
      await saveUserToFirestore(userModel);

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Unexpected error during sign-up: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        firebaseAuth.signOut(),
        googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw AuthException('Failed to sign out: ${e.toString()}');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      final User? user = firebaseAuth.currentUser;
      if (user == null) return null;

      // Get complete user data from Firestore
      final userFromFirestore = await getUserFromFirestore(user.uid);

      return userFromFirestore ?? UserModel(
        uid: user.uid,
        email: user.email,
        displayName: user.displayName,
        photoURL: user.photoURL,
        emailVerified: user.emailVerified,
        role: 'user',
      );
    } catch (e) {
      throw AuthException('Failed to get current user: ${e.toString()}');
    }
  }

  @override
  Future<bool> isUserSignedIn() async {
    try {
      return firebaseAuth.currentUser != null;
    } catch (e) {
      throw AuthException('Failed to check auth status: ${e.toString()}');
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthException('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyOTP(String otp) async {
    try {
      throw const AuthException('OTP verification not implemented yet');
    } catch (e) {
      throw AuthException('OTP verification failed: ${e.toString()}');
    }
  }

  // ✅ ADD THESE MISSING FIRESTORE METHODS:

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

  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Incorrect password provided.';
      case 'email-already-in-use':
        return 'An account already exists with this email address.';
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
