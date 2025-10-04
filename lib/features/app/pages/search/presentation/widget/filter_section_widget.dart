import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../provider/cubit/search_filter/search_filter_cubit.dart';
import '../provider/cubit/search_filter/search_filter_state.dart';

class FilterSectionWidget extends StatelessWidget {
  final TextEditingController? searchController; // Add controller to access search query

  const FilterSectionWidget({super.key, this.searchController});

  @override
  Widget build(BuildContext context) {
    final List<String> availableFacilities = [
      'Wi-Fi',
      'Air Conditioning',
      'Parking',
      'Laundry',
      'Gym',
      'Kitchen',
      'TV',
      'Security',
      'Swimming Pool',
      'Study Room',
    ];
    final List<String> availableRoomTypes = [
      'Single',
      '2 Share',
      '3 Share',
      'Shared',
      'Dormitory',
    ];

    return Container(
      padding: EdgeInsets.all(padding),
      height: height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: BlocBuilder<SearchFilterCubit, SearchFilterState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: customGrey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              height10,
              const Text(
                'Filters',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              height20,
              const Text('Distance (km)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              RangeSlider(
                values: const RangeValues(2, 20),
                min: 2,
                max: 20,
                divisions: 18,
                activeColor: mainColor,
                inactiveColor: secondaryColor,
                labels: const RangeLabels('2', '20'),
                onChanged: (RangeValues values) {
                  // No-op: Distance filter is UI-only
                },
              ),
              height20,
              // Facilities Filter
              const Text('Facilities', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 5.0,
                children: availableFacilities.map((facility) {
                  return ChoiceChip(
                    label: Text(facility),
                    selected: state.facilities.contains(facility),
                    onSelected: (selected) {
                      context.read<SearchFilterCubit>().toggleFacility(facility);
                    },
                    selectedColor: mainColor,
                    backgroundColor: textFieldColor,
                    labelStyle: TextStyle(
                      color: state.facilities.contains(facility) ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              height20,
              // Room Types Filter
              const Text('Room Types', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              Wrap(
                spacing: 5.0,
                children: availableRoomTypes.map((roomType) {
                  return ChoiceChip(
                    label: Text(roomType),
                    selected: state.roomTypes.contains(roomType),
                    onSelected: (selected) {
                      context.read<SearchFilterCubit>().toggleRoomType(roomType);
                    },
                    selectedColor: mainColor,
                    backgroundColor: textFieldColor,
                    labelStyle: TextStyle(
                      color: state.roomTypes.contains(roomType) ? Colors.white : Colors.black,
                    ),
                  );
                }).toList(),
              ),
              height20,
              // Price Range Slider
              const Text('Price Range (₹/month)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              RangeSlider(
                values: state.priceRange,
                min: 1000,
                max: 10000,
                divisions: 18,
                activeColor: mainColor,
                inactiveColor: secondaryColor,
                labels: RangeLabels(
                  state.priceRange.start.round().toString(),
                  state.priceRange.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  context.read<SearchFilterCubit>().updatePriceRange(values);
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      context.read<SearchFilterCubit>().resetFilters();
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ),
                  TextButton(
                    onPressed: () {
                      context.read<SearchFilterCubit>().resetFilters();
                    },
                    child: const Text('Clear Filters', style: TextStyle(color: Colors.blue, fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Pass the current search query when applying filters
                      context.read<SearchFilterCubit>().applyFilters(context, searchController?.text ?? '');
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Apply Filters', style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}