import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';

import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/services/current_user.dart';
import '../../../../../../../core/widgets/custom_green_button_widget.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';
import '../../provider/bloc/add_cooupant/add_occupant_bloc.dart';
import '../../screen/confirm_booking_screen.dart';
import '../../screen/edit_occupant_screen.dart';

class SelectOccupantSection extends StatelessWidget {
  const SelectOccupantSection({
    super.key,
    required this.currentState,
    required this.room,
    required this.addOccupantBloc,
  });

  final AddOccupantLoaded currentState;
  final Map<String, dynamic> room;
  final AddOccupantBloc addOccupantBloc;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleTextWidget(title: 'Choose Occupant'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: currentState.occupants.length,
          itemBuilder: (context, index) {
            final occupant = currentState.occupants[index];
            print('========image url=======${occupant.profileImageUrl}');
            return InkWell(
              onTap: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmBookingScreen(
                      room: room,
                      occupant: occupant,
                    ),
                  ),
                );
              },
              child: Card(
                color: secondaryColor,
                child: ListTile(
                  title: Text(occupant.name),
                  subtitle: Text(occupant.phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: mainColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                        ),
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditOccupantScreen(
                                occupant: occupant,
                                room: room,
                              ),
                            ),
                          );
                          if (result == true) {
                            context
                                .read<AddOccupantBloc>()
                                .add(FetchOccupantsEvent(CurrentUser().uId!));
                          }
                        },
                        child: Text('Edit'),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: () {
                          addOccupantBloc.add(
                            DeleteOccupantEvent(occupant.id!),
                          );
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        height20,
        CustomGreenButtonWidget(
          name: 'Add New Occupant',
          onPressed: () {
            addOccupantBloc.add(ToggleFormEvent(true));
          },
        ),
      ],
    );
  }
}
