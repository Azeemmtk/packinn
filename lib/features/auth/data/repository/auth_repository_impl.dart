import 'package:packinn/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:packinn/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:packinn/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:packinn/features/auth/domain/entities/user_entity.dart';
import 'package:packinn/features/auth/domain/repository/auth_repository.dart';

import '../model/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource remoteDataSourceAuth;
  final UserRemoteDataSource remoteDataSourceUser;
  final AuthLocalDataSource sharedPrefsDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSourceAuth,
    required this.remoteDataSourceUser,
    required this.sharedPrefsDataSource,
  });

  @override
  Future<UserEntity?> googleSignIn() async {
    print('AuthRepositoryImpl: Starting Google Sign-In');
    final user = await remoteDataSourceAuth.googleSignIn();
    if (user != null) {
      print(
          'AuthRepositoryImpl: Google Sign-In successful, saving user profile');
      final userModel = UserModel(
        uid: user.uid,
        email: user.email,
        name: user.name ?? '',
        phone: '',
        age: 0,
        address: '',
        role: 'user',
        profileImageUrl: '',
      );
      await remoteDataSourceUser.saveUserProfile(userModel);
      print('AuthRepositoryImpl: Setting isAuthenticated = true');
      await sharedPrefsDataSource.setAuthenticated(true);
      return userModel.toEntity();
    } else {
      print('AuthRepositoryImpl: Google Sign-In failed or cancelled');
    }
    return null;
  }

  @override
  Future<void> signOut() async {
    print('AuthRepositoryImpl: Starting sign out');
    await remoteDataSourceAuth.signOut();
    print('AuthRepositoryImpl: Setting isAuthenticated = false');
    await sharedPrefsDataSource.setAuthenticated(false);
  }

  @override
  Future<UserEntity?> checkAuthStatus() async {
    final isAuthenticated = await sharedPrefsDataSource.isAuthenticated();
    print(
        'AuthRepositoryImpl: isAuthenticated from SharedPreferences = $isAuthenticated');
    if (!isAuthenticated) {
      print(
          'AuthRepositoryImpl: Not authenticated in SharedPreferences, returning null');
      return null;
    }
    final user = await remoteDataSourceAuth.checkAuthStatus();
    print(
        'AuthRepositoryImpl: Firebase user check result = ${user != null ? user.uid : null}');
    return user;
  }
}
