import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/auth/presentation/screens/sign_in_screen.dart';
import '../../../auth/presentation/provider/bloc/auth_bloc.dart';
import '../../../auth/presentation/provider/bloc/auth_state.dart';
import '../widgets/build_bottom_navigation_bar.dart';
import '../widgets/build_small_hostel_card.dart';
import '../widgets/build_top_rated_hostel_card.dart';
import '../widgets/home_custom_appbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        print('HomeScreen BlocConsumer received state: $state');
        if (state is AuthUnauthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const SignInScreen()),
            (route) => false,
          );
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[100],
          body: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const HomeCustomAppbarWidget(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: EdgeInsets.all(padding),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Top Rated',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Icon(
                                        Icons.star,
                                        color: Colors.yellow[600],
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                  Text(
                                    'See more...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                              height10,
                              SizedBox(
                                height: height * 0.36,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    BuildTopRatedHostelCard(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuBSfG5TOl4RG5fvOcGZAewnVQFFtnPgLfAJu_lCJp4TAoRSOEmJNsgi723NM7KmZB48BRgjugJpo3hkiSIDfB4nyjX5gaf5A8LkkiDojl5mlWyNAVmF2SEBSNXjaqER6D5WObVHSDqWFbQgNjpr6simyF5VwUt5IEczDBe50J744_qTQmvBz4yn_g0ac-_OP-WzdTe8Ok7GSd919mhUWkLi3PjWtSD609gO5rw_57kj3Hknl5pj8efmvN1zyzrDJWwq_8JR5hHruouE',
                                      title: 'STANZA LIVING HOSTEL',
                                      location: 'RAMYA NAGARI, BAKULNAGAR',
                                      rent: 4500,
                                      rating: 4.0,
                                      distance: 5,
                                    ),
                                    const SizedBox(width: 16),
                                    BuildTopRatedHostelCard(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD-zWyKUBbtsnVnXBGLWShcjddZHvEDr5JHcsMKR8VFonVTnSYwJUOIXa1KmTM5WbwbCRbD_9Bd7n_5xtYzNi5xX8FDJ1vl1iStt9LF38aUzYe4zK_Cc2jtzJwCDdSqJMNQA_I4nJhX7HqUKo2f8jT7_byqYsTAlUgtqdNo5VcjOakIwVN6CpGj-WbidLMkJv8RCzkm9ert3253Bnlo5qGIJZgsFKcOgf5FYyqB2p4YivV9hHIJQzmNRJAPLNtZjOx8ugx8gAvZYCQD',
                                      title: 'SUMMIT HOSTEL',
                                      location: 'RAMYA NAGARI, BAKULNAGAR',
                                      rent: 4500,
                                      rating: 3.5,
                                      distance: 10,
                                    ),
                                  ],
                                ),
                              ),
                              height20,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Hostels',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'See more...',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: mainColor,
                                    ),
                                  ),
                                ],
                              ),
                              height10,
                              SizedBox(
                                height: 170,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    BuildSmallHostelCard(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuA5e6q8Lm5kJCOtoH3doKvCsRssYLnI7x1PfKNcC268VHPUWsbFSXjbfpkZI0ktDThqRHb2Y1PI1BXqAvRDvW-6_Qs5upQIhfZSEH_VSq-8USfhgU_-0D0uVi5pUc62OldGm2T30wFXX8GGLaYuziGzN_xsRo_E4vSdthkNb_1DkGXoJTgDfcnRYxfs0HoMcbYUyoZK28osMyZoMU85wYPPHWpVMxIrPrNaxvEJR2j_ittroRTKqsbSTySPayWx55sJdLYAcBF6ugCt',
                                      title: 'Summit Hostel',
                                      distance: '4500/MONTH',
                                      rent: '2 Km',
                                    ),
                                    const SizedBox(width: 16),
                                    BuildSmallHostelCard(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuD2Cucggyvj0HtGYGq18xoswHH5JbcnUOYjEbG5j_rXT03t0Czm1nouHBsfo9HGLex_Hg-9G-murd5IQaQHXOmhaJQ55teJjxsmhBNYIfJ9rewUN5HIP2myVX7aXSWBxzZGca5otp4WZtRDlUETaU1B31zMeXde5f8MOix-ZeCtjcCRdGo3dZPxYDK-ULgWPY5wWoDPU3kxcSX2uM7IvycBLZCYAUtsS6-W0_DlH7qUoD5-uWvXrp1OQVabfon1Yx0xkwPSLC7oCCJR',
                                      title: 'Summit Hostel',
                                      rent: '4500/MONTH',
                                      distance: '2 Km',
                                    ),
                                    const SizedBox(width: 16),
                                    BuildSmallHostelCard(
                                      imageUrl:
                                          'https://lh3.googleusercontent.com/aida-public/AB6AXuDp52uAe2l_G8S07YZMlF_q4nh-Q2ByscOw4ZTKAMRxGXE9TSVywPf24GcZc0iIbTJUs2ZbVl_Bwa6Pzhw4EmlcgWmwpukdorhKlxNOF0hahahAIyVBOPxIOeVck9t1JSy_LKaHe1dykgwNszZqfsipNYQxoRrV2veQuBgVNLjLiJD8wi4-T_wRqve7hImr3DRjtcdLGSWc5ZbdD2mzEXezDqnN6sBTC8KZpJtmVpLCPNNoDEp6g24WXwMwqnsxyi480Cfzhzor3N18',
                                      title: 'Summit Hostel',
                                      distance: '4500/MONTH',
                                      rent: '2 Km',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: const BuildBottomNavigationBar(),
        );
      },
    );
  }
}
