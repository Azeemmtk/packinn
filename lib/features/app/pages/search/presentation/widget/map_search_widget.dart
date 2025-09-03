import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../../../core/constants/const.dart';
import 'map_search_hostel_card_widget.dart';

class MapSearchWidget extends StatelessWidget {
  MapSearchWidget({super.key});

  final MapController _mapController = MapController();
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        SizedBox(
          height: height * 0.45,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: LatLng(9.9312, 76.2673),
                initialZoom: 13.0,
                // onTap: (tapPosition, point) {
                //   context.read<LocationCubit>().selectLocation(point);
                // },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'PackInhApp/1.0 (contact: aseemmtk@example.com)',
                ),
              ],
            ),
          ),
        ),
        height10,
        SizedBox(
          height: height * 0.2,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return MapSearchHostelCardWidget();
              },
              separatorBuilder: (context, index) =>  width5,
              itemCount: 5,
          ),
        )
      ],
    );
  }
}