import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import '../provider/bloc/add_cooupant/add_occupant_bloc.dart';
import '../widgets/edit_occupant/edit_guardian_section.dart';
import '../widgets/edit_occupant/edit_image_section.dart';
import '../widgets/edit_occupant/edit_occupant_section.dart';

class EditOccupantScreen extends StatefulWidget {
  final OccupantEntity occupant;
  final Map<String, dynamic> room;

  const EditOccupantScreen(
      {super.key, required this.occupant, required this.room});

  @override
  _EditOccupantScreenState createState() => _EditOccupantScreenState();
}

class _EditOccupantScreenState extends State<EditOccupantScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _ageController;
  late final TextEditingController _guardianNameController;
  late final TextEditingController _guardianPhoneController;
  late final TextEditingController _guardianRelationController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with occupant data
    _nameController = TextEditingController(text: widget.occupant.name);
    _phoneController = TextEditingController(text: widget.occupant.phone);
    _ageController =
        TextEditingController(text: widget.occupant.age.toString());
    _guardianNameController =
        TextEditingController(text: widget.occupant.guardian?.name ?? '');
    _guardianPhoneController =
        TextEditingController(text: widget.occupant.guardian?.phone ?? '');
    _guardianRelationController =
        TextEditingController(text: widget.occupant.guardian?.relation ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    _guardianNameController.dispose();
    _guardianPhoneController.dispose();
    _guardianRelationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AddOccupantBloc>()
            ..add(UpdateOccupantEvent(
              name: widget.occupant.name,
              phone: widget.occupant.phone,
              age: widget.occupant.age,
              guardianName: widget.occupant.guardian?.name ?? '',
              guardianPhone: widget.occupant.guardian?.phone ?? '',
              guardianRelation: widget.occupant.guardian?.relation ?? '',
              idProofUrl: widget.occupant.idProofUrl,
              addressProofUrl: widget.occupant.addressProofUrl,
              profileImageUrl: widget.occupant.profileImageUrl,
            )),
        ),
        BlocProvider(
          create: (context) => getIt<OccupantFieldCubit>()
            ..updateField(
              name: widget.occupant.name,
              phone: widget.occupant.phone,
              age: widget.occupant.age.toString(),
              guardianName: widget.occupant.guardian?.name ?? '',
              guardianPhone: widget.occupant.guardian?.phone ?? '',
              guardianRelation: widget.occupant.guardian?.relation ?? '',
              idProofUrl: widget.occupant.idProofUrl,
              addressProofUrl: widget.occupant.addressProofUrl,
            ),
        ),
      ],
      child: BlocConsumer<AddOccupantBloc, AddOccupantState>(
        listener: (context, state) {
          if (state is AddOccupantSuccess) {
            Navigator.pop(context, true);
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
              final currentState = state is AddOccupantLoaded
                  ? state
                  : AddOccupantLoaded(
                      name: textFieldState.name,
                      phone: textFieldState.phone,
                      age: int.tryParse(textFieldState.age),
                      guardianName: textFieldState.guardianName,
                      guardianPhone: textFieldState.guardianPhone,
                      guardianRelation: textFieldState.guardianRelation,
                      idProof: null,
                      addressProof: null,
                      idProofUrl: widget.occupant.idProofUrl,
                      addressProofUrl: widget.occupant.addressProofUrl,
                      occupants: [],
                      showForm: true,
                    );

              // Update controllers only if the text field state changes significantly
              if (_nameController.text != textFieldState.name) {
                _nameController.text = textFieldState.name;
              }
              if (_phoneController.text != textFieldState.phone) {
                _phoneController.text = textFieldState.phone;
              }
              if (_ageController.text != textFieldState.age) {
                _ageController.text = textFieldState.age;
              }
              if (_guardianNameController.text != textFieldState.guardianName) {
                _guardianNameController.text = textFieldState.guardianName;
              }
              if (_guardianPhoneController.text !=
                  textFieldState.guardianPhone) {
                _guardianPhoneController.text = textFieldState.guardianPhone;
              }
              if (_guardianRelationController.text !=
                  textFieldState.guardianRelation) {
                _guardianRelationController.text =
                    textFieldState.guardianRelation;
              }

              return Scaffold(
                body: Stack(
                  children: [
                    Column(
                      children: [
                        CustomAppBarWidget(title: 'Edit Occupant Details'),
                        Expanded(
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: EdgeInsets.all(padding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  EditOccupantSection(
                                    addOccupantBloc: addOccupantBloc,
                                    textFieldCubit: textFieldCubit,
                                    currentState: currentState,
                                    nameController: _nameController,
                                    phoneController: _phoneController,
                                    ageController: _ageController,
                                  ),
                                  EditGuardianSection(
                                    addOccupantBloc: addOccupantBloc,
                                    textFieldCubit: textFieldCubit,
                                    currentState: currentState,
                                    guardianNameController:
                                        _guardianNameController,
                                    guardianPhoneController:
                                        _guardianPhoneController,
                                    guardianRelationController:
                                        _guardianRelationController,
                                    ageText: _ageController.text,
                                  ),
                                  EditImageSection(
                                    addOccupantBloc: addOccupantBloc,
                                    textFieldCubit: textFieldCubit,
                                    currentState: currentState,
                                  ),
                                  CustomGreenButtonWidget(
                                    name: 'Save and Continue',
                                    onPressed: () {
                                      final error =
                                          textFieldCubit.validateAndGetError();
                                      if (error == null) {
                                        addOccupantBloc.add(SaveOccupantEvent(
                                          widget.room,
                                          occupantId: widget.occupant.id,
                                        ));
                                      } else {
                                        textFieldCubit.validateFields(
                                            isSubmitted: true);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text(error)),
                                        );
                                      }
                                    },
                                  ),
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
