import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:packinn/core/constants/stripe.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/theme/app_theme.dart';
import 'package:packinn/features/auth/presentation/screens/splash_screen.dart';
import 'core/constants/const.dart';
import 'features/app/pages/home/presentation/provider/bloc/hostel/hostel_bloc.dart';
import 'features/auth/presentation/provider/bloc/auth_bloc.dart';
import 'features/auth/presentation/provider/bloc/email/email_auth_bloc.dart';
import 'features/auth/presentation/provider/bloc/google/google_auth_bloc.dart';
import 'features/auth/presentation/provider/bloc/otp/otp_auth_bloc.dart';
import 'features/auth/presentation/provider/cubit/sign_in_cubit.dart';
import 'features/auth/presentation/provider/cubit/sign_up_cubit.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');

  //Stripe
  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY']!;

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Dependencies
  await initializeDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    getSize(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => getIt<AuthBloc>()),
        BlocProvider(create: (context) => getIt<EmailAuthBloc>()),
        BlocProvider(create: (context) => getIt<GoogleAuthBloc>()),
        BlocProvider(create: (context) => getIt<OtpAuthBloc>()),
        BlocProvider(
          create: (context) => getIt<SignUpCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<SignInCubit>(),
        ),
        BlocProvider(
          create: (context) => getIt<HostelBloc>()..add(FetchHostelsData()),
        )
      ],
      child: MaterialApp(
        title: 'PackInn',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.light,
        home: const SplashScreen(),
      ),
    );
  }
}
