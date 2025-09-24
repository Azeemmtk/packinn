import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/model/user_model.dart';
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

      final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw const AuthException('Failed to sign in with Google');
      }

      final userModel = UserModel(
        uid: user.uid,
        email: user.email!,
        displayName: user.displayName ?? '',
        photoURL: user.photoURL,
        phone: user.phoneNumber ?? 'unKnown',
        emailVerified: user.emailVerified,
        role: 'user',
        walletBalance: 0.0,
      );

      final hostelOwnerQuery = await firestore
          .collection('hostel_owners')
          .where('email', isEqualTo: user.email)
          .get();

      if (hostelOwnerQuery.docs.isNotEmpty) {
        await signOut();
        throw const AuthException(
            'This account is already registered in the hostel owner app.');
      }

      final existingUser = await getUserFromFirestore(user.uid);

      if (existingUser == null) {
        await saveUserToFirestore(userModel);
        return userModel;
      } else {
        if (existingUser.role != 'user') {
          String cRole = existingUser.role;
          await signOut();
          throw AuthException(
              'This account is already registered in the $cRole app.');
        }
        return existingUser;
      }
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Google sign-in failed');
    } catch (e) {
      throw AuthException('${e.toString()}');
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
      final User? firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser == null) return null;

      // Get user data from Firestore first
      final userFromFirestore = await getUserFromFirestore(firebaseUser.uid);

      if (userFromFirestore != null) {
        // Fill in any null values with Firebase Auth data
        return UserModel(
          uid: userFromFirestore.uid,
          email: userFromFirestore.email ?? firebaseUser.email,
          displayName: userFromFirestore.displayName ?? firebaseUser.displayName,
          photoURL: userFromFirestore.photoURL ?? firebaseUser.photoURL,
          address: userFromFirestore.address ?? 'Address',
          emailVerified: userFromFirestore.emailVerified ?? firebaseUser.emailVerified,
          role: userFromFirestore.role ?? 'user',
          walletBalance: userFromFirestore.walletBalance,
        );
      }

      // If no Firestore data exists, create UserModel from Firebase Auth
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        address: 'Address',
        emailVerified: firebaseUser.emailVerified,
        role: 'user',
        walletBalance: 0.0,
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
      print('Attempting to send password reset email for: $email');
      await firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent successfully for: $email');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in sendPasswordResetEmail: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Error in sendPasswordResetEmail: ${e.toString()}');
      throw AuthException('Failed to send password reset email: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserPassword(String uid, String newPassword) async {
    try {
      final user = firebaseAuth.currentUser;
      if (user == null || user.uid != uid) {
        throw const AuthException('User not authenticated or UID mismatch');
      }
      await user.updatePassword(newPassword);
      print('Password updated successfully for UID: $uid');
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException in updateUserPassword: ${e.code} - ${e.message}');
      throw AuthException(_getAuthErrorMessage(e.code));
    } catch (e) {
      print('Error in updateUserPassword: ${e.toString()}');
      throw AuthException('Failed to update password: ${e.toString()}');
    }
  }

  @override
  Future<void> saveUserToFirestore(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.uid).set(user.toFirestore());
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

      await firestore.collection('users').doc(user.uid).update(updateData);

      return user;
    } catch (e) {
      throw AuthException(
          'Failed to update user in Firestore: ${e.toString()}');
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
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'too-many-requests':
        return 'Too many unsuccessful attempts. Please try again later.';
      case 'user-disabled':
        return 'This user account has been disabled.';
      case 'requires-recent-login':
        return 'Please sign in again to update your password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }

  @override
  Future<String> sendOtp(String phoneNumber) async {
    final completer = Completer<String>();
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (_) {},
        verificationFailed: (error) {
          completer.completeError(
              AuthFailure(error.message ?? 'Verification failed'));
        },
        codeSent: (verId, forceResendingToken) {
          print('dataSourse=========$verId');
          completer.complete(verId);
        },
        codeAutoRetrievalTimeout: (_) {
          if (!completer.isCompleted) {
            completer
                .completeError(AuthFailure('Code auto-retrieval timed out'));
          }
        },
      );
      return await completer.future;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> verifyOtp(String verificationId, String otp) async {
    try {
      final credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otp);
      final userCredential =
      await firebaseAuth.signInWithCredential(credential);
      final User? user = userCredential.user;
      if (user == null) {
        throw const AuthException('Failed to create user account');
      }
      return UserModel(
        uid: user.uid,
        phoneVerified: true,
      );
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;

      if (firebaseUser == null) {
        throw AuthFailure('Failed to signIn');
      }
      final userFromFirestore = await getUserFromFirestore(firebaseUser.uid);
      if (userFromFirestore != null) {
        if (userFromFirestore.role != 'user') {
          String cRole = userFromFirestore.role;
          await signOut();
          throw AuthFailure(
              'This account is already registered in the $cRole app.');
        }
        return userFromFirestore;
      }
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email,
        displayName: firebaseUser.displayName,
        photoURL: firebaseUser.photoURL,
        emailVerified: firebaseUser.emailVerified,
        role: 'user',
      );
    } on FirebaseAuthException catch (e) {
      print(e.code);
      throw AuthFailure(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmail(
      String name, String email, String phone, String password) async {
    print('remote=========== $name, $email, $phone, $password..............');
    try {
      final hostelOwnerQuery = await firestore
          .collection('hostel_owners')
          .where('email', isEqualTo: email)
          .get();

      if (hostelOwnerQuery.docs.isNotEmpty) {
        throw const AuthException(
            'This account is already registered in the hostel owner app.');
      }

      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthFailure('Failed to create user');
      }

      final userModel = UserModel(
          uid: firebaseUser.uid,
          name: name,
          displayName: name,
          email: email,
          phone: phone,
          phoneVerified: true,
          emailVerified: firebaseUser.emailVerified,
          role: 'user',
        walletBalance: 0.0
      );
      await saveUserToFirestore(userModel);
      return userModel;
    } catch (e) {
      throw AuthFailure(e.toString());
    }
  }
}