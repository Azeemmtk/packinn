import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/hostel/hostel_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/screen/hostel_details_screen.dart';
import '../widgets/home/build_small_hostel_card.dart';
import '../widgets/home/build_top_rated_hostel_card.dart';
import '../widgets/home/home_custom_appbar_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xffe6ffee),
      body: Column(
        children: [
          const HomeCustomAppbarWidget(),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                final completer = Completer<void>();
                context.read<HostelBloc>().add(FetchHostelsData());
                final subscription = context.read<HostelBloc>().stream.listen((state) {
                  if (state is HostelLoaded || state is HostelError) {
                    completer.complete();
                  }
                });
                await completer.future;
                subscription.cancel();
                return;
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Column(
                    children: [
                      height10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          // Text(
                          //   'See more...',
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: mainColor,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: height * 0.34,
                        child: BlocBuilder<HostelBloc, HostelState>(
                          builder: (context, state) {
                            if (state is HostelLoading) {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: mainColor,
                                ),
                              );
                            } else if (state is HostelLoaded) {
                              if (state.hostels.isEmpty) {
                                return const Center(
                                  child: Text('Hostels Not Available'),
                                );
                              }
                              return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.hostels.length,
                                itemBuilder: (context, index) {
                                  final hostel = state.hostels[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HostelDetailsScreen(hostel: hostel),
                                        ),
                                      );
                                    },
                                    child: BuildTopRatedHostelCard(
                                      imageUrl: hostel.mainImageUrl ?? imagePlaceHolder,
                                      title: hostel.name,
                                      location: hostel.placeName,
                                      rent: (hostel.rooms[0]['rate'] as num).toDouble(),
                                      rating: hostel.rating ?? 0.0,
                                      distance: 5,
                                    ),
                                  );
                                },
                              );
                            } else if (state is HostelError) {
                              return Center(
                                child: Text(state.message),
                              );
                            }
                            return const Center(
                              child: Text('Hostel Not Available'),
                            );
                          },
                        ),
                      ),
                      height20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'All hostels',
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
                      BlocBuilder<HostelBloc, HostelState>(
                        builder: (context, state) {
                          if (state is HostelLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            );
                          } else if (state is HostelLoaded) {
                            if (state.hostels.isEmpty) {
                              return SizedBox(
                                height: 19,
                                child: const Center(
                                  child: Text('Hostels Not Available'),
                                ),
                              );
                            }
                            return SizedBox(
                              height: 190,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.hostels.length,
                                itemBuilder: (context, index) {
                                  final hostel = state.hostels[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => HostelDetailsScreen(hostel: hostel),
                                        ),
                                      );
                                    },
                                    child: BuildSmallHostelCard(
                                      imageUrl: hostel.mainImageUrl ?? imagePlaceHolder,
                                      title: hostel.name,
                                      distance: '2 Km',
                                      rent: (hostel.rooms[0]['rate'] as num).toDouble(),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else if (state is HostelError) {
                            return Center(
                              child: Text(state.message),
                            );
                          }
                          return const Center(
                            child: Text('Hostel Not Available'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
