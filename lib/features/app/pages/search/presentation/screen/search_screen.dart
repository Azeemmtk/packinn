import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/features/app/pages/home/presentation/screen/hostel_details_screen.dart';
import '../../../../../../core/di/injection.dart';
import '../../../../../../core/services/geolocator_service.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../provider/bloc/map_search/map_search_bloc.dart';
import '../provider/bloc/search/search_bloc.dart';
import '../provider/bloc/search/search_state.dart';
import '../provider/cubit/loacation/location_cubit.dart';
import '../provider/cubit/loacation/location_state.dart';
import '../provider/cubit/search_filter/search_filter_cubit.dart';
import '../provider/cubit/search_filter/search_filter_state.dart';
import '../widget/hostel_search_result_card.dart';
import '../widget/map_search_widget.dart';
import '../widget/search_field_widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => SearchFilterCubit()),
        BlocProvider(
            create: (context) =>
            LocationCubit(GeolocationService())..getCurrentLocation()),
        BlocProvider(create: (context) => getIt<SearchBloc>()), //
        BlocProvider(create: (context) => getIt<MapSearchBloc>()), // MapSearchBloc
      ],
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize:
              const Size.fromHeight(kToolbarHeight),
          child: CustomAppBarWidget(
            title: 'Search',
            enableChat: true,
          ),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: height * 0.8,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: padding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  height10,
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
                      return Text(
                        locationText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 5),
                  BlocBuilder<SearchFilterCubit, SearchFilterState>(
                    builder: (context, filterState) {
                      return SearchFieldWidget(
                        focusNode: _searchFocusNode,
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                      );
                    },
                  ),
                  height20,
                  Expanded(
                    child: BlocBuilder<SearchBloc, SearchState>(
                      builder: (context, state) {
                        if (_searchQuery.isNotEmpty) {
                          if (state is SearchInitial) {
                            return const Center(
                              child: Text(
                                'Search hostel',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          } else if (state is SearchLoading) {
                            return const Center(
                                child: Column(
                                  children: [
                                    CircularProgressIndicator(color: mainColor,),
                                    Text('Getting hostel details'),
                                  ],
                                ));
                          } else if (state is SearchLoaded) {
                            if (state.hostels.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No hostels found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              padding: EdgeInsets.zero,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => HostelDetailsScreen(
                                          hostel: state.hostels[index],
                                        ),
                                      ),
                                    );
                                  },
                                  child: HostelSearchResultCard(
                                      hostel: state.hostels[index]),
                                );
                              },
                              separatorBuilder: (context, index) =>
                                  const SizedBox(height: 10),
                              itemCount: state.hostels.length,
                            );
                          } else if (state is SearchError) {
                            return Center(
                              child: Text(
                                state.message,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }
                          return const SizedBox();
                        } else {
                          return MapSearchWidget();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
