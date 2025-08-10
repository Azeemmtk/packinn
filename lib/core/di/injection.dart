import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in_package;
import 'package:packinn/features/app/pages/search/data/datasource/hostel_search_remote_data_source.dart';
import 'package:packinn/features/app/pages/search/data/repository/hostel_search_repository_impl.dart';
import 'package:packinn/features/app/pages/search/domain/repository/hostel_search_repository.dart';
import 'package:packinn/features/app/pages/search/domain/usecases/search_hostel.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/bloc/search/search_bloc.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/cubit/search_filter/search_filter_cubit.dart';
import 'package:packinn/features/auth/domain/usecase/reset_password.dart';
import 'package:packinn/features/auth/domain/usecase/verify_otp.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/otp_cubit.dart';
import '../../features/app/pages/home/data/datasource/hostel_remote_data_source.dart';
import '../../features/app/pages/home/data/repository/hostel_repository_impl.dart';
import '../../features/app/pages/home/domain/repository/hostel_repository.dart';
import '../../features/app/pages/home/domain/usecases/get_hostel_data.dart';
import '../../features/app/pages/home/presentation/provider/bloc/hostel_bloc.dart';
import '../../features/app/pages/search/presentation/provider/cubit/loacation/location_cubit.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/auth_remote_data_source_impl.dart';
import '../../features/auth/data/repository/auth_repository_impl.dart';
import '../../features/auth/domain/repository/auth_repository.dart';
import '../../features/auth/domain/usecase/check_auth_status.dart';
import '../../features/auth/domain/usecase/google_sign_in.dart'
    as google_sign_in_usecase;
import '../../features/auth/domain/usecase/send-otp.dart';
import '../../features/auth/domain/usecase/sign_in_with_email.dart';
import '../../features/auth/domain/usecase/sign_out.dart';
import '../../features/auth/domain/usecase/sign_up_with_email.dart';
import '../../features/auth/presentation/provider/bloc/auth_bloc.dart';
import '../../features/auth/presentation/provider/bloc/email/email_auth_bloc.dart';
import '../../features/auth/presentation/provider/bloc/google/google_auth_bloc.dart';
import '../../features/auth/presentation/provider/bloc/otp/otp_auth_bloc.dart';
import '../../features/auth/presentation/provider/cubit/sign_in_cubit.dart';
import '../../features/auth/presentation/provider/cubit/sign_up_cubit.dart';
import '../services/geolocator_service.dart';

final getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  // External Dependencies
  getIt.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<google_sign_in_package.GoogleSignIn>(
    () => google_sign_in_package.GoogleSignIn(
      scopes: ['email', 'profile'],
    ),
  );

  // Services
  getIt.registerLazySingleton<GeolocationService>(() => GeolocationService());

  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      firebaseAuth: getIt<FirebaseAuth>(),
      googleSignIn: getIt<google_sign_in_package.GoogleSignIn>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );

  getIt.registerLazySingleton<HostelRemoteDataSource>(
    () => HostelRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<HostelSearchRemoteDataSource>(
    () => HostelSearchRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<HostelRepository>(
    () => HostelRepositoryImpl(getIt<HostelRemoteDataSource>()),
  );

  getIt.registerLazySingleton<HostelSearchRepository>(
    () => HostelSearchRepositoryImpl(getIt<HostelSearchRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(() => CheckAuthStatus(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => google_sign_in_usecase.GoogleSignIn(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpWithEmail(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOut(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => VerifyOtp(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SendOtp(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => ResetPassword(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetHostelData(getIt<HostelRepository>()));
  getIt.registerLazySingleton(
      () => SearchHostels(getIt<HostelSearchRepository>()));

  // BLoCs
  getIt.registerFactory(
    () => EmailAuthBloc(
      signInWithEmail: getIt<SignInWithEmail>(),
      signUpWithEmail: getIt<SignUpWithEmail>(),
      resetPassword: getIt<ResetPassword>(),
    ),
  );
  getIt.registerFactory(
    () => GoogleAuthBloc(
      googleSignIn: getIt<google_sign_in_usecase.GoogleSignIn>(),
    ),
  );
  getIt.registerFactory(
    () => OtpAuthBloc(
      sendOtp: getIt<SendOtp>(),
      verifyOtp: getIt<VerifyOtp>(),
      firestore: getIt<FirebaseFirestore>(),
    ),
  );
  getIt.registerFactory(
    () => AuthBloc(
      checkAuthStatus: getIt<CheckAuthStatus>(),
      signOut: getIt<SignOut>(),
      emailAuthBloc: getIt<EmailAuthBloc>(),
      googleAuthBloc: getIt<GoogleAuthBloc>(),
      otpAuthBloc: getIt<OtpAuthBloc>(),
    ),
  );
  getIt.registerFactory(
    () => HostelBloc(
      getHostelData: getIt<GetHostelData>(),
    ),
  );

  getIt.registerFactory(
    () => SearchBloc(searchHostels: getIt<SearchHostels>()),
  );

  // Cubits
  getIt.registerFactory(() => OtpCubit());
  getIt.registerFactory(() => SignUpCubit());
  getIt.registerFactory(() => SignInCubit());
  getIt.registerFactory(() => SearchFilterCubit());
  getIt.registerFactory(() => LocationCubit(getIt<GeolocationService>()));
}
