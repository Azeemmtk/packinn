import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import '../../../../../../core/model/user_model.dart';
import '../provider/bloc/profile/profile_bloc.dart';
import '../widgets/profile/profile_content_widget.dart';

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
                      return ProfileContentWidget(user: state.user);
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
}
