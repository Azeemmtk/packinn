import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../../core/constants/const.dart';
import '../../../../../../../core/services/current_user.dart';
import '../../../../../../../core/widgets/custom_green_button_widget.dart';
import '../../../../../../../core/widgets/title_text_widget.dart';
import '../../provider/bloc/add_cooupant/add_occupant_bloc.dart';
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
        TitleTextWidget(title: 'Select Occupant'),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: currentState.occupants.length,
          itemBuilder: (context, index) {
            final occupant = currentState.occupants[index];
            return InkWell(
              onTap: () async {
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
              child: ListTile(
                title: Text(occupant.name),
                subtitle: Text(occupant.phone),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        addOccupantBloc.add(
                          SelectOccupantEvent(
                            occupant,
                            room,
                          ),
                        );
                      },
                      child: Text('Select'),
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
