import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/widgets/custom_snack_bar.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/bloc/map_search/map_search_bloc.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/bloc/map_search/map_search_state.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/cubit/loacation/location_cubit.dart';
import 'package:packinn/features/app/pages/search/presentation/provider/cubit/loacation/location_state.dart';
import '../provider/bloc/map_search/map_search_event.dart';
import 'map_search_hostel_card_widget.dart';

class MapSearchWidget extends StatefulWidget {
  MapSearchWidget({super.key});

  @override
  _MapSearchWidgetState createState() => _MapSearchWidgetState();
}

class _MapSearchWidgetState extends State<MapSearchWidget> {
  final MapController _mapController = MapController();
  LatLng _initialCenter = LatLng(9.9312, 76.2673);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: height * 0.45,
          child: BlocConsumer<LocationCubit, LocationState>(
            listener: (context, state) {
              if (state is LocationLoaded) {
                _mapController.move(
                    LatLng(state.latitude, state.longitude), 13.0);
              }
            },
            builder: (context, locationState) {
              if (locationState is LocationLoaded) {
                _initialCenter =
                    LatLng(locationState.latitude, locationState.longitude);
              }
              return BlocConsumer<MapSearchBloc, MapSearchState>(
                listener: (context, state) {
                  if (state is MapSearchError) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      ScaffoldMessenger.of(context).showSnackBar(customSnackBar(
                          text: state.message.contains('timed out')
                              ? 'The server is taking too long to respond. Please try again.'
                              : 'Error: ${state.message}'));
                    });
                  }
                },
                builder: (context, mapState) {
                  List<CircleMarker> circles = [];
                  List<Marker> markers = [];
                  if (mapState is MapSearchLoaded) {
                    circles.add(
                      CircleMarker(
                        point: mapState.selectedPoint,
                        radius: 5000,
                        useRadiusInMeter: true,
                        color: Colors.blue.withOpacity(0.3),
                        borderColor: Colors.blue,
                        borderStrokeWidth: 2,
                      ),
                    );
                    markers = mapState.hostels.map((hostel) {
                      return Marker(
                        point: LatLng(hostel.latitude, hostel.longitude),
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.location_pin,
                          color: Colors.red,
                          size: 30,
                        ),
                      );
                    }).toList();
                  }

                  return ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _initialCenter,
                        initialZoom: 13.0,
                        onTap: (tapPosition, point) {
                          context.read<MapSearchBloc>().add(TapOnMap(point));
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName:
                              'PackInhApp/1.0 (contact: aseemmtk@example.com)',
                        ),
                        CircleLayer(circles: circles),
                        MarkerLayer(markers: markers),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ),
        height10,
        SizedBox(
          height: height * 0.2,
          child: BlocBuilder<MapSearchBloc, MapSearchState>(
            builder: (context, state) {
              if (state is MapSearchLoading) {
                return const Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(
                      color: mainColor,
                    ),
                    Text('Fetching nearby hostels'),
                  ],
                ));
              } else if (state is MapSearchLoaded) {
                if (state.hostels.isEmpty) {
                  return const Center(
                      child: Text('No hostels found in this area'));
                }
                return ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    final hostel = state.hostels[index];
                    final distance = const Distance().as(
                      LengthUnit.Kilometer,
                      state.selectedPoint,
                      LatLng(hostel.latitude, hostel.longitude),
                    );
                    return MapSearchHostelCardWidget(
                      hostel: hostel,
                      distance: distance,
                    );
                  },
                  separatorBuilder: (context, index) => width5,
                  itemCount: state.hostels.length,
                );
              } else if (state is MapSearchError) {
                return Center(
                    child: Text('Failed to load hostels. Please try again.'));
              }
              return Card(
                elevation: 2,
                color: Colors.grey.shade200,
                child: const Center(
                  child: Text(
                    'Tap on the map to search for hostels',
                    style: TextStyle(fontSize: 17,),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
