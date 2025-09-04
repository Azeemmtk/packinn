import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/features/app/pages/my_booking/presentation/widgets/custom_my_hostel_card.dart';
import '../provider/bloc/my_booking/my_booking_bloc.dart';
import '../provider/bloc/my_booking/my_booking_event.dart';
import '../provider/bloc/my_booking/my_booking_state.dart';
import 'my_hostel_details_screen.dart';

class MyBookingScreen extends StatelessWidget {
  const MyBookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.instance<MyBookingsBloc>()..add(LoadMyBookings()),
      child: Scaffold(
        body: Column(
          children: [
            const CustomAppBarWidget(
              title: 'My Booking',
              enableChat: true,
            ),
            Expanded(
              child: BlocBuilder<MyBookingsBloc, MyBookingsState>(
                builder: (context, state) {
                  if (state is MyBookingsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is MyBookingsLoaded) {
                    if (state.bookings.isEmpty) {
                      return const Center(child: Text('No bookings found'));
                    }
                    return Padding(
                      padding: EdgeInsets.only(left: padding, right: padding),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final booking = state.bookings[index];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MyHostelDetailsScreen(
                                    hostel: booking.hostel,
                                    room: booking.room,
                                    occupantName: booking.occupant.name,
                                  ),
                                ),
                              );
                            },
                            child: CustomMyHostelCard(
                              imageUrl: booking.hostel.mainImageUrl ?? 'https://placeholder.com',
                              title: booking.hostel.name,
                              location: booking.hostel.placeName,
                              occupantName: booking.occupant.name,
                              rent: booking.room['rate'] as double,
                              rating: booking.hostel.rating ?? 0.0,
                              distance: 0, // Hardcoded
                            ),
                          );
                        },
                        separatorBuilder: (context, index) => height10,
                        itemCount: state.bookings.length,
                      ),
                    );
                  } else if (state is MyBookingsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}