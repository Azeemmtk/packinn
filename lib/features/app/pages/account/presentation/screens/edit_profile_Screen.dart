import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import '../../../../../auth/data/model/user_model.dart';
import '../provider/bloc/edit_profile/edit_profile_bloc.dart';
import '../widgets/edit/edit_profile_form.dart';

class EditProfileScreen extends StatelessWidget {
  final UserModel user;
  const EditProfileScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final editProfileBloc = GetIt.instance<EditProfileBloc>();

    return BlocProvider.value(
      value: editProfileBloc,
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is EditProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child:  Scaffold(
          body: Column(
            children: [
              CustomAppBarWidget(title: 'Edit Profile'),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: SingleChildScrollView(
                    child: EditProfileForm(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
