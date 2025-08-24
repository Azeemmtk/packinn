import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/pages/home/presentation/screen/hostel_details_screen.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/services/geolocator_service.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../provider/bloc/search/search_bloc.dart';
import '../provider/bloc/search/search_state.dart';
import '../provider/cubit/loacation/location_cubit.dart';
import '../provider/cubit/loacation/location_state.dart';
import '../provider/cubit/search_filter/search_filter_cubit.dart';
import '../provider/cubit/search_filter/search_filter_state.dart';
import '../widget/hostel_search_result_card.dart';
import '../widget/map_search_widget.dart';
import '../widget/search_field_widget.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchFilterCubit()),
        BlocProvider(
            create: (context) =>
            LocationCubit(GeolocationService())..getCurrentLocation()),
        BlocProvider(create: (context) => getIt<SearchBloc>()),
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              CustomAppBarWidget(
                title: 'Search',
                enableChat: true,
              ),
              height20,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<LocationCubit, LocationState>(
                      builder: (context, state) {
                        String locationText = 'Location';
                        if (state is LocationLoading) {
                          locationText = 'Loading location...';
                        } else if (state is LocationLoaded) {
                          locationText = state.placeName;
                        } else if (state is LocationError) {
                          locationText = 'Location unavailable';
                        }
                        return Text(locationText);
                      },
                    ),
                    height5,
                    MapSearchWidget(),
                    BlocBuilder<SearchFilterCubit, SearchFilterState>(
                      builder: (context, filterState) {
                        return BlocBuilder<SearchBloc, SearchState>(
                          builder: (context, searchState) {
                            return SearchFieldWidget();
                          },
                        );
                      },
                    ),
                    height10,
                    BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (state is SearchInitial) {
                          return Center(
                            child: Column(
                              children: [
                                SizedBox(height: 100),
                                Text(
                                  'Search hostel',
                                  style: TextStyle(fontSize: 16, color: Colors.grey),
                                ),
                              ],
                            ),
                          );
                        } else if (state is SearchLoading) {
                          return Center(child: CircularProgressIndicator());
                        } else if (state is SearchLoaded) {
                          if (state.hostels.isEmpty) {
                            return Center(
                              child: Column(
                                children: [
                                  SizedBox(height: 100),
                                  Text(
                                    'No hostels found',
                                    style: TextStyle(fontSize: 16, color: Colors.grey),
                                  ),
                                ],
                              ),
                            );
                          }
                          return SizedBox(
                            height: height * 0.75,
                            child: ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            HostelDetailsScreen(
                                              hostel: state.hostels[index],
                                            ),
                                      ),
                                    );
                                  },
                                  child: HostelSearchResultCard(
                                      hostel: state.hostels[index]),
                                );
                              },
                              separatorBuilder: (context, index) => height10,
                              itemCount: state.hostels.length,
                            ),
                          );
                        } else if (state is SearchError) {
                          return Center(
                            child: Text(
                              state.message,
                              style: TextStyle(fontSize: 16, color: Colors.red),
                            ),
                          );
                        }
                        return SizedBox();
                      },
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
}