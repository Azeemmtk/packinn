import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/features/app/pages/account/presentation/widgets/logout_button_widget.dart';
import 'package:packinn/features/app/pages/account/presentation/widgets/profile_list_items.dart';

import '../../../../../auth/presentation/provider/bloc/auth_bloc.dart';
import '../provider/bloc/profile/profile_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const list = [
      'Profile',
      'Reports',
      'Add Compliant',
      'Help',
      'About',
      'Terms & Policy',
    ];
    return BlocProvider(
      create: (context) => GetIt.instance<ProfileBloc>(),
      child: BlocListener<AuthBloc, dynamic>(
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
                      height: height * 0.45,
                      child: ListView.separated(
                        padding: EdgeInsets.zero,
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
      ),
    );
  }
}