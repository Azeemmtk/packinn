import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in_package;
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/check_auth_status.dart';
import '../../features/auth/domain/usecase/google_sign_in.dart' as google_sign_in_usecase;
import '../../features/auth/domain/usecase/sign_in_with_email.dart';
import '../../features/auth/domain/usecase/sign_out.dart';
import '../../features/auth/domain/usecase/sign_up_with_email.dart';
import '../../features/auth/presentation/block/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<google_sign_in_package.GoogleSignIn>(
        () => google_sign_in_package.GoogleSignIn(
      scopes: ['email', 'profile'],
    ),
  );

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
        () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<google_sign_in_package.GoogleSignIn>(),
    ),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(() => CheckAuthStatus(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => google_sign_in_usecase.GoogleSignIn(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));

  // BLoC
  getIt.registerFactory(
        () => AuthBloc(
      checkAuthStatus: getIt<CheckAuthStatus>(),
      googleSignIn: getIt<google_sign_in_usecase.GoogleSignIn>(),
      signInWithEmail: getIt<SignInWithEmail>(),
      signUpWithEmail: getIt<SignUpWithEmail>(),
      signOut: getIt<SignOut>(),
    ),
  );
}
