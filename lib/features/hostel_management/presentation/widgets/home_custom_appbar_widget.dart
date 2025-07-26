import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/const.dart';
import '../../../auth/presentation/block/auth_bloc.dart';
import '../../../auth/presentation/block/auth_event.dart';
import '../../../auth/presentation/block/auth_state.dart';
import '../../../auth/presentation/screens/sign_in_screen.dart';


class HomeCustomAppbarWidget extends StatelessWidget {
  const HomeCustomAppbarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          // Navigate to sign-in screen when signed out
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const SignInScreen()),
                (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(width * 0.1),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height20,
              height10,
              // Profile and Notification Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4, vertical: 4),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: state is AuthAuthenticated &&
                                  state.user.photoURL != null
                                  ? NetworkImage(state.user.photoURL!)
                                  : const NetworkImage(
                                'https://lh3.googleusercontent.com/aida-public/AB6AXuCV2BT4s-9VHuSPY0hF-wXQMqcHzjl76lbXSVv_vE0XLm1gsNZI5oNbo0-8QH4PKU91PHAolqn_CcwBb389vu7vQYqqBUOUMhXqsShZWO31BlMz7CvnOCaXCFFWbJdzpAY7t-LuAua5C7QdIlE4szqdRZHLk0eRRegTfrRdcPTQ0zwMT7Qg_H9qDgH_1LkagoKJh-jg0IZdNFyEXFbbMHhdMebFNrRl4c6kvzqEbHXX0LCWv695yNAC_PLfzrnCiImB4jU7LZ0d_FLg',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  state is AuthAuthenticated &&
                                      state.user.displayName?.isNotEmpty == true
                                      ? state.user.displayName!
                                      : 'Azeem ali',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.grey[500],
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Maradu, ernakualm',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[500],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                          ],
                        ),
                      );
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'notifications':
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Notifications feature coming soon!'),
                              ),
                            );
                            break;
                          case 'logout':
                            _showLogoutDialog(context);
                            break;
                        }
                      },
                      itemBuilder: (BuildContext context) => [
                        const PopupMenuItem<String>(
                          value: 'notifications',
                          child: Row(
                            children: [
                              Icon(Icons.notifications_outlined, size: 20),
                              SizedBox(width: 12),
                              Text('Notifications'),
                            ],
                          ),
                        ),
                        const PopupMenuDivider(),
                        const PopupMenuItem<String>(
                          value: 'logout',
                          child: Row(
                            children: [
                              Icon(Icons.logout, size: 20, color: Colors.red),
                              SizedBox(width: 12),
                              Text('Logout', style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      child: IconButton(
                        icon: const Icon(Icons.notifications_none),
                        onPressed: null, // Handled by PopupMenuButton
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Title
              const Text(
                'Explore',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF374151),
                ),
              ),
              RichText(
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                  children: [
                    TextSpan(text: 'Nearby '),
                    TextSpan(
                      text: 'Hostels',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop();
                // Show logout success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Logged out successfully'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
                // Trigger sign out event
                context.read<AuthBloc>().add(const AuthSignOutEvent());
              },
            ),
          ],
        );
      },
    );
  }
}
