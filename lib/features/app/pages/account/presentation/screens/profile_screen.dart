import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/details_row_widget.dart';

import '../../../../../auth/data/model/user_model.dart';
import '../provider/bloc/profile/profile_bloc.dart';
import 'edit_profile_Screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<ProfileBloc>()
        ..add(LoadProfileEvent(CurrentUser().uId!)),
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBarWidget(title: 'Profile'),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    if (state is ProfileLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ProfileLoaded) {
                      return _buildProfileContent(context, state.user);
                    } else if (state is ProfileError) {
                      return Center(child: Text(state.message));
                    }
                    return const Center(child: Text('Unable to load profile'));
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, UserModel user) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage:
                user.photoURL != null ? NetworkImage(user.photoURL!) : null,
            child: user.photoURL == null
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          SizedBox(height: height * 0.02),
          DetailsRowWidget(
            title: 'Display Name',
            value: user.displayName ?? '.....',
            isBold: true,
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Email',
            value: user.email ?? '.....',
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Phone',
            value: user.phone ?? '.....',
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Name',
            value: user.displayName ?? 'null',
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Age',
            value: user.age?.toString() ?? '.....',
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Address',
            value: user.address ?? '.....',
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Role',
            value: user.role,
          ),
          Divider(),
          DetailsRowWidget(
            title: 'Wallet Balance',
            value: user.walletBalance?.toString() ?? 'null',
          ),
          SizedBox(height: height * 0.02),
          ElevatedButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditProfileScreen(user: user),
                ),
              );

              if (result == true) {
                context.read<ProfileBloc>()
                  ..add(LoadProfileEvent(CurrentUser().uId!));
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.05),
              ),
            ),
            child: const Text('Edit Profile'),
          ),
        ],
      ),
    );
  }
}
