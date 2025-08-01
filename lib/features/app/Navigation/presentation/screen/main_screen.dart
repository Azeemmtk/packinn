import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/features/app/Navigation/cubit/bottom_nav_cubit.dart';
import 'package:packinn/features/app/pages/account/presentation/account_screen.dart';
import 'package:packinn/features/app/pages/my_room/presentation/my_room_screen.dart';
import 'package:packinn/features/app/pages/search/presentation/search_screen.dart';
import 'package:packinn/features/app/pages/wallet/presentation/wallet_screen.dart';

import '../../../pages/home/presentation/screen/home_screen.dart';
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
        return MyRoomScreen();
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
