import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/current_user.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/home/presentation/screen/confirm_booking_screen.dart';
import '../provider/bloc/add_cooupant/add_occupant_bloc.dart';
import '../widgets/add_occupant/AddNewOccupantSection.dart';
import '../widgets/add_occupant/select_occupant_section.dart';

class AddOccupantScreen extends StatelessWidget {
  final Map<String, dynamic> room;

  AddOccupantScreen({super.key, required this.room});

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  final _guardianNameController = TextEditingController();
  final _guardianPhoneController = TextEditingController();
  final _guardianRelationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => getIt<AddOccupantBloc>()
              ..add(FetchOccupantsEvent(CurrentUser().uId!))),
        BlocProvider(create: (context) => getIt<OccupantFieldCubit>()),
      ],
      child: BlocConsumer<AddOccupantBloc, AddOccupantState>(
        listener: (context, state) {
          if (state is AddOccupantSuccess) {
            print(state.room);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ConfirmBookingScreen(
                  room: state.room,
                  occupant: state.occupant,

                ),
              ),
            );
          } else if (state is AddOccupantError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
            builder: (context, textFieldState) {
              final addOccupantBloc = context.read<AddOccupantBloc>();
              final textFieldCubit = context.read<OccupantFieldCubit>();
              final currentState =
                  state is AddOccupantLoaded ? state : AddOccupantLoaded();

              _nameController.text = currentState.name;
              _phoneController.text = currentState.phone;
              _ageController.text = currentState.age?.toString() ?? '';
              _guardianNameController.text = currentState.guardianName;
              _guardianPhoneController.text = currentState.guardianPhone;
              _guardianRelationController.text = currentState.guardianRelation;

              return Scaffold(
                body: Stack(
                  children: [
                    Column(
                      children: [
                        CustomAppBarWidget(title: 'Add Occupant Details'),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!currentState.showForm &&
                                      currentState.occupants.isNotEmpty) ...[
                                    SelectOccupantSection(
                                      currentState: currentState,
                                      room: room,
                                      addOccupantBloc: addOccupantBloc,
                                    ),
                                  ] else ...[
                                    AddNewOccupantSection(
                                      addOccupantBloc: addOccupantBloc,
                                      textFieldCubit: textFieldCubit,
                                      currentState: currentState,
                                      room: room,
                                      nameController: _nameController,
                                      phoneController: _phoneController,
                                      ageController: _ageController,
                                      guardianNameController: _guardianNameController,
                                      guardianPhoneController: _guardianPhoneController,
                                      guardianRelationController: _guardianRelationController,
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state is AddOccupantLoading)
                      Container(
                        color: Colors.black54,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
