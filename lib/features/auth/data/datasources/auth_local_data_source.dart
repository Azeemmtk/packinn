import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<bool> isAuthenticated();
  Future<void> setAuthenticated(bool isAuthenticated);
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  const AuthLocalDataSourceImpl({required this.sharedPreferences});
  static const String _isAuthenticatedKey = 'is_authenticated';

  @override
  Future<bool> isAuthenticated() async {
    final isAuthenticated =
        sharedPreferences.getBool(_isAuthenticatedKey) ?? false;
    print('AuthLocalDataSource: isAuthenticated = $isAuthenticated');
    return isAuthenticated;
  }

  @override
  Future<void> setAuthenticated(bool isAuthenticated) async {
    print('AuthLocalDataSource: Setting isAuthenticated = $isAuthenticated');
    await sharedPreferences.setBool(_isAuthenticatedKey, isAuthenticated);
  }
}
