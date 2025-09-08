import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart' as google_sign_in_package;
import 'package:packinn/core/services/cloudinary_services.dart';
import 'package:packinn/core/services/stripe_services.dart';
import 'package:packinn/features/app/pages/account/data/datasource/user_profile_remote_data_source.dart';
import 'package:packinn/features/app/pages/account/data/repository/user_profile_repository_impl.dart';
import 'package:packinn/features/app/pages/account/domain/repository/user_profile_repository.dart';
import 'package:packinn/features/app/pages/account/domain/usecases/get_user_use_case.dart';
import 'package:packinn/features/app/pages/account/domain/usecases/update_user_use_case.dart';
import 'package:packinn/features/app/pages/account/presentation/provider/bloc/edit_profile/edit_profile_bloc.dart';
import 'package:packinn/features/app/pages/account/presentation/provider/bloc/profile/profile_bloc.dart';
import 'package:packinn/features/app/pages/chat/data/datasource/chat_remote_data_source.dart';
import 'package:packinn/features/app/pages/chat/data/datasource/owner_remote_data_source.dart';
import 'package:packinn/features/app/pages/chat/data/repository/chat_repository_impl.dart';
import 'package:packinn/features/app/pages/chat/data/repository/owner_repository_impl.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/chat_repository.dart';
import 'package:packinn/features/app/pages/chat/domain/repository/owner_repository.dart';
import 'package:packinn/features/app/pages/chat/domain/usecases/create_chat_use_case.dart';
import 'package:packinn/features/app/pages/chat/domain/usecases/get_chats_use_case.dart';
import 'package:packinn/features/app/pages/chat/domain/usecases/get_messages_use_case.dart';
import 'package:packinn/features/app/pages/chat/domain/usecases/get_owner_details_use_case.dart';
import 'package:packinn/features/app/pages/chat/domain/usecases/send_message_use_case.dart';
import 'package:packinn/features/app/pages/chat/presentation/providers/bloc/allchats/all_chat_bloc.dart';
import 'package:packinn/features/app/pages/chat/presentation/providers/bloc/chat/chat_bloc.dart';
import 'package:packinn/features/app/pages/home/data/datasource/occupant_remote_data_sourse.dart';
import 'package:packinn/features/app/pages/home/data/datasource/review_remote_data_source.dart';
import 'package:packinn/features/app/pages/home/data/repository/occupant_repository_impl.dart';
import 'package:packinn/features/app/pages/home/data/repository/review_repository_impl.dart';
import 'package:packinn/features/app/pages/home/domain/repository/occupants_repository.dart';
import 'package:packinn/features/app/pages/home/domain/repository/review_repository.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/add_review_use_case.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/delete_occupant.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/fetch_occupants.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/get_review_use_case.dart';
import 'package:packinn/features/app/pages/home/domain/usecases/save_occupant.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/review/review_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/my_booking/data/datasourse/booking_remote_data_source.dart';
import 'package:packinn/features/app/pages/my_booking/domain/repository/booking_repository.dart';
import 'package:packinn/features/app/pages/my_booking/domain/usecases/get_my_bookings.dart';
import 'package:packinn/features/app/pages/my_booking/presentation/provider/bloc/my_booking/my_booking_bloc.dart';
import 'package:packinn/features/app/pages/search/data/datasource/hostel_search_remote_data_source.dart';
import 'package:packinn/features/app/pages/search/data/datasource/overpass_remote_data_source.dart';
import 'package:packinn/features/app/pages/search/data/repository/hostel_map_search_repository_impl.dart';
import 'package:packinn/features/app/pages/search/data/repository/hostel_search_repository_impl.dart';
import 'package:packinn/features/app/pages/search/domain/repository/hostel_map_search_repository.dart';
import 'package:packinn/features/app/pages/search/domain/repository/hostel_search_repository.dart';
import 'package:packinn/features/app/pages/search/domain/usecases/search_hostel.dart';
import 'package:packinn/features/app/pages/search/domain/usecases/search_hostels_nearby.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/bloc/map_search/map_search_bloc.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/bloc/search/search_bloc.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/cubit/search_filter/search_filter_cubit.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/occupant_edit_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/payment_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/datasourse/wallet_remote_data_source.dart';
import 'package:packinn/features/app/pages/wallet/data/repository/wallet_repository_impl.dart';
import 'package:packinn/features/app/pages/wallet/domain/repository/wallet_repository.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/add_to_wallet_usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/deduct_from_wallet_usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/get_payment_usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/get_transaction_usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/get_wallet_balance_usecase.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/save_payment_use_case.dart';
import 'package:packinn/features/app/pages/wallet/domain/usecases/update_occupant_usecase.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/payment/payment_bloc.dart';
import 'package:packinn/features/app/pages/wallet/presentation/provider/bloc/wallet/wallet_bloc.dart';
import 'package:packinn/features/auth/domain/usecase/reset_password.dart';
import 'package:packinn/features/auth/domain/usecase/verify_otp.dart';
import 'package:packinn/features/auth/presentation/provider/cubit/otp_cubit.dart';
import '../../features/app/pages/home/data/datasource/hostel_remote_data_source.dart';
import '../../features/app/pages/home/data/repository/hostel_repository_impl.dart';
import '../../features/app/pages/home/domain/repository/hostel_repository.dart';
import '../../features/app/pages/home/domain/usecases/get_hostel_data.dart';
import '../../features/app/pages/home/presentation/provider/bloc/hostel/hostel_bloc.dart';
import '../../features/app/pages/my_booking/data/repository/booking_repository_impl.dart';
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
import '../services/image_picker_service.dart';

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

  getIt.registerLazySingleton<Dio>(
    () => Dio(),
  );

  // Services
  getIt.registerLazySingleton<GeolocationService>(() => GeolocationService());
  getIt.registerLazySingleton<CloudinaryService>(() => CloudinaryService());
  getIt.registerLazySingleton<ImagePickerService>(() => ImagePickerService());
  getIt.registerLazySingleton<StripeService>(() => StripeService());

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

  getIt.registerLazySingleton<OccupantRemoteDataSource>(
    () => OccupantRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<OccupantEditRemoteDataSource>(
    () => OccupantEditRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<PaymentRemoteDataSource>(
    () => PaymentRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<OwnerRemoteDataSource>(
    () => OwnerRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<OverpassRemoteDataSource>(
    () => OverpassRemoteDataSource(getIt<Dio>()),
  );

  getIt.registerLazySingleton<ReviewRemoteDataSource>(
    () => ReviewRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );

  getIt.registerLazySingleton<WalletRemoteDataSource>(
        () => WalletRemoteDataSourceImpl(getIt<FirebaseFirestore>()),
  );
  getIt.registerLazySingleton<UserProfileRemoteDataSource>(
        () => UserProfileRemoteDataSourceImpl(firestore:  getIt<FirebaseFirestore>()),
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

  getIt.registerLazySingleton<OccupantsRepository>(
    () => OccupantRepositoryImpl(getIt<OccupantRemoteDataSource>()),
  );

  getIt.registerLazySingleton<WalletRepository>(
    () => WalletRepositoryImpl(getIt<OccupantEditRemoteDataSource>(),
        getIt<PaymentRemoteDataSource>(),
        getIt<WalletRemoteDataSource>(),
    ),
  );

  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getIt<BookingRemoteDataSource>()),
  );

  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(getIt<ChatRemoteDataSource>()),
  );

  getIt.registerLazySingleton<OwnerRepository>(
    () => OwnerRepositoryImpl(getIt<OwnerRemoteDataSource>()),
  );

  getIt.registerLazySingleton<HostelMapSearchRepository>(
    () => HostelMapSearchRepositoryImpl(getIt<OverpassRemoteDataSource>()),
  );

  getIt.registerLazySingleton<ReviewRepository>(
        () => ReviewRepositoryImpl(getIt<ReviewRemoteDataSource>()),
  );

  getIt.registerLazySingleton<UserProfileRepository>(
        () => UserProfileRepositoryImpl(remoteDataSource: getIt<UserProfileRemoteDataSource>()),
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
  getIt.registerLazySingleton(() => SaveOccupant(getIt<OccupantsRepository>()));
  getIt.registerLazySingleton(
      () => FetchOccupants(getIt<OccupantsRepository>()));
  getIt.registerLazySingleton(
      () => DeleteOccupant(getIt<OccupantsRepository>()));
  getIt.registerLazySingleton(
      () => GetMyBookingsUseCase(getIt<BookingRepository>()));
  getIt.registerLazySingleton(
      () => SavePaymentUseCase(getIt<WalletRepository>()));
  getIt.registerLazySingleton(
      () => GetPaymentsUseCase(getIt<WalletRepository>()));
  getIt.registerLazySingleton(
      () => UpdateOccupantUseCase(getIt<WalletRepository>()));

  getIt.registerLazySingleton(() => CreateChatUseCase(getIt<ChatRepository>()));
  getIt.registerLazySingleton(() => GetChatsUseCase(getIt<ChatRepository>()));
  getIt
      .registerLazySingleton(() => GetMessagesUseCase(getIt<ChatRepository>()));
  getIt
      .registerLazySingleton(() => SendMessageUseCase(getIt<ChatRepository>()));

  getIt.registerLazySingleton(
      () => GetOwnerDetailsUseCase(getIt<OwnerRepository>()));

  getIt.registerLazySingleton(
      () => SearchHostelsNearby(getIt<HostelMapSearchRepository>()));

  getIt.registerLazySingleton(
          () => AddReviewUseCase(getIt<ReviewRepository>()));

  getIt.registerLazySingleton(() => GetReviewsUseCase(getIt<ReviewRepository>()));

  getIt.registerLazySingleton(() => AddToWalletUseCase(getIt<WalletRepository>()));
  getIt.registerLazySingleton(() => DeductFromWalletUseCase(getIt<WalletRepository>()));
  getIt.registerLazySingleton(() => GetTransactionsUseCase(getIt<WalletRepository>()));
  getIt.registerLazySingleton(() => GetWalletBalanceUseCase(getIt<WalletRepository>()));


  getIt.registerLazySingleton(() => GetUserUseCase(getIt<UserProfileRepository>()));
  getIt.registerLazySingleton(() => UpdateUserUseCase(getIt<UserProfileRepository>()));



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

  getIt.registerFactory(
    () => AddOccupantBloc(
        cloudinaryService: getIt<CloudinaryService>(),
        deleteOccupant: getIt<DeleteOccupant>(),
        saveOccupant: getIt<SaveOccupant>(),
        fetchOccupants: getIt<FetchOccupants>()),
  );

  getIt.registerFactory(
    () => PaymentBloc(
        getIt<StripeService>(),
        getIt<SavePaymentUseCase>(),
        getIt<UpdateOccupantUseCase>(),
        getIt<DeductFromWalletUseCase>(),
      getIt<WalletRepository>(),
    ),
  );
  getIt.registerFactory(() =>
      MyBookingsBloc(getMyBookingsUseCase: getIt<GetMyBookingsUseCase>()));
  getIt.registerFactory(() => WalletBloc(
      getIt<GetPaymentsUseCase>(),
    getIt<GetWalletBalanceUseCase>(),
    getIt<AddToWalletUseCase>(),
    getIt<GetTransactionsUseCase>(),
    getIt<StripeService>(),
  ));

  getIt.registerFactory(() => AllChatBloc(getIt<GetChatsUseCase>()));
  getIt.registerFactoryParam<ChatBloc, String, void>(
    (chatId, _) => ChatBloc(
      getMessagesUseCase: getIt<GetMessagesUseCase>(),
      sendMessageUseCase: getIt<SendMessageUseCase>(),
      chatId: chatId,
    ),
  );

  getIt.registerFactory(() => MapSearchBloc(getIt<SearchHostelsNearby>()));

  getIt.registerFactory(() => ReviewBloc(addReviewUseCase: getIt<AddReviewUseCase>(),getReviewsUseCase: getIt<GetReviewsUseCase>()));


  getIt.registerFactory(() => ProfileBloc(
      getUserUseCase: getIt<GetUserUseCase>(),
  ));

  getIt.registerFactory(() => EditProfileBloc(
    updateUserUseCase: getIt<UpdateUserUseCase>(),
  ));




  // Cubits
  getIt.registerFactory(() => OtpCubit());
  getIt.registerFactory(() => SignUpCubit());
  getIt.registerFactory(() => SignInCubit());
  getIt.registerFactory(() => SearchFilterCubit());
  getIt.registerFactory(() => OccupantFieldCubit());
  getIt.registerFactory(() => LocationCubit(getIt<GeolocationService>()));
}
