import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/pages/account/presentation/screens/account_screen.dart';
import 'package:packinn/features/app/pages/my_booking/presentation/screens/my_booking_screen.dart';
import 'package:packinn/features/app/pages/search/presentation/screen/search_screen.dart';
import 'package:packinn/features/app/pages/wallet/presentation/screens/wallet_screen.dart';
import '../../../pages/home/presentation/screen/home_screen.dart';
import '../../cubit/bottom_nav_cubit.dart';
import '../widget/build_bottom_navigation_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  Widget _getScreen(BottomNavItem item) {
    switch (item) {
      case BottomNavItem.home:
        return HomeScreen();
      case BottomNavItem.search:
        return SearchScreen();
      case BottomNavItem.myRoom:
        return MyBookingScreen();
      case BottomNavItem.wallet:
        return WalletScreen();
      case BottomNavItem.account:
        return AccountScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BottomNavCubit(),
      child: BlocBuilder<BottomNavCubit, BottomNavItem>(
          builder: (context, state) {
            return Scaffold(
              body: _getScreen(state),
              bottomNavigationBar: BuildBottomNavigationBar(),
            );
          },
      ),
    );
  }
}
