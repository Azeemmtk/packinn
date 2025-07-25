import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:packinn/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:packinn/features/auth/data/datasources/user_remote_data_source.dart';
import 'package:packinn/features/auth/data/repository/auth_repository_impl.dart';
import 'package:packinn/features/auth/domain/repository/auth_repository.dart';
import 'package:packinn/features/auth/domain/usecase/check_auth_status.dart';
import 'package:packinn/features/auth/domain/usecase/google_sign_in.dart';
import 'package:packinn/features/auth/domain/usecase/sign_out.dart';
import 'package:packinn/features/auth/presentation/block/auth_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart' as google;
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
// BLoC
sl.registerFactory(() => AuthBloc(
googleSignIn: sl<GoogleSignIn>(),
signOut: sl<SignOut>(),
checkAuthStatus: sl<CheckAuthStatus>(),
firebaseAuth: sl<FirebaseAuth>(),
));

// Use Cases
sl.registerLazySingleton(() => GoogleSignIn(sl()));
sl.registerLazySingleton(() => SignOut(sl()));
sl.registerLazySingleton(() => CheckAuthStatus(sl()));

// Repositories
sl.registerLazySingleton<AuthRepository>(
() => AuthRepositoryImpl(
remoteDataSourceAuth: sl(),
remoteDataSourceUser: sl(),
sharedPrefsDataSource: sl<AuthLocalDataSource>(),
),
);

// Data Sources
sl.registerLazySingleton<AuthDataSource>(
() => AuthRemoteDataSourceImpl(
firebaseAuth: sl(),
googleSignIn: sl<google.GoogleSignIn>(),
),
);
sl.registerLazySingleton<UserRemoteDataSource>(
() => UserRemoteDataSourceImpl(firestore: sl()),
);
sl.registerLazySingleton<AuthLocalDataSource>(
() => AuthLocalDataSourceImpl(sharedPreferences: sl()),
);

// External
sl.registerLazySingleton(() => FirebaseAuth.instance);
sl.registerLazySingleton(() => google.GoogleSignIn());
sl.registerLazySingleton(() => FirebaseFirestore.instance);
sl.registerSingletonAsync<SharedPreferences>(() async {
final prefs = await SharedPreferences.getInstance();
print('Injection: SharedPreferences initialized');
return prefs;
});
}