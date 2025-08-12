import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/features/app/pages/account/presentation/screens/profile_screen.dart';

import '../../../../../auth/presentation/provider/bloc/auth_bloc.dart';
import '../../../../../auth/presentation/provider/bloc/email/email_auth_state.dart';
import '../../../../../auth/presentation/screens/sign_in_screen.dart';
import '../widgets/logout_button_widget.dart';
import '../widgets/profile_list_items.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const list = [
      'Profile',
      'Favourite',
      'Add Compliant',
      'Help',
      'About',
      'Terms & Policy',
    ];
    return BlocListener<AuthBloc, dynamic>(
      listener: (context, state) {},
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWidget(
              title: 'Account',
              enableChat: true,
            ),
            Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.55,
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ProfileListItems(
                          text: list[index],
                          selectedIndex: index,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: list.length,
                    ),
                  ),
                  LogoutButtonWidget(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
