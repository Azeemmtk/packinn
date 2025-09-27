import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_app_bar_widget.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:packinn/core/entity/occupant_entity.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import '../provider/bloc/add_cooupant/add_occupant_bloc.dart';
import '../widgets/edit_occupant/edit_occupant_form.dart';
import '../widgets/edit_occupant/occupant_form_controllers.dart';

class EditOccupantScreen extends StatefulWidget {
  final OccupantEntity occupant;
  final Map<String, dynamic> room;

  const EditOccupantScreen({
    super.key,
    required this.occupant,
    required this.room,
  });

  @override
  _EditOccupantScreenState createState() => _EditOccupantScreenState();
}

class _EditOccupantScreenState extends State<EditOccupantScreen> {
  late final OccupantFormControllers _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = OccupantFormControllers(widget.occupant);
  }

  @override
  void dispose() {
    _controllers.dispose();
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
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWidget(title: 'Edit Occupant Details'),
            Expanded(
              child: EditOccupantForm(
                occupant: widget.occupant,
                room: widget.room,
                controllers: _controllers,
              ),
            ),
          ],
        ),
      ),
    );
  }
}