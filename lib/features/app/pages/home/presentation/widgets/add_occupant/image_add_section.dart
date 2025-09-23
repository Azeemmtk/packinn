import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/widgets/confirm_booking/image_view_dialog.dart';

import 'image_button.dart';

class ImageAddSection extends StatelessWidget {
  final AddOccupantBloc addOccupantBloc;
  final OccupantFieldCubit textFieldCubit;
  final AddOccupantLoaded currentState;

  const ImageAddSection({
    super.key,
    required this.addOccupantBloc,
    required this.textFieldCubit,
    required this.currentState,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OccupantFieldCubit, OccupantFieldState>(
      builder: (context, textFieldState) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ImageButton(
                  title: 'Occupant image',
                  label: 'Add occupant\nImage',
                  image: currentState.profileImage,
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(profileImage: image);
                      addOccupantBloc.add(UpdateOccupantEvent(profileImage: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  onImageTap: currentState.profileImage != null
                      ? () {
                    showDialog(
                      context: context,
                      builder: (_) => ImageViewDialog(image: currentState.profileImage!),
                    );
                  }
                      : null,
                ),
                width10,
                ImageButton(
                  label: 'Add ID\nProof',
                  title: 'ID Proof',
                  image: currentState.idProof,
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(idProof: image);
                      addOccupantBloc.add(UpdateOccupantEvent(idProof: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  onImageTap: currentState.idProof != null
                      ? () {
                    showDialog(
                      context: context,
                      builder: (_) => ImageViewDialog(image: currentState.idProof!),
                    );
                  }
                      : null,
                ),
                width10,
                ImageButton(
                  label: 'Add address\nProof',
                  title: 'Address Proof',
                  image: currentState.addressProof,
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(addressProof: image);
                      addOccupantBloc.add(UpdateOccupantEvent(addressProof: image));
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  onImageTap: currentState.addressProof != null
                      ? () {
                    showDialog(
                      context: context,
                      builder: (_) => ImageViewDialog(image: currentState.addressProof!),
                    );
                  }
                      : null,
                ),
              ],
            ),
            if (textFieldState.idProofError != null) ...[
              height5,
              Text(
                textFieldState.idProofError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            if (textFieldState.addressProofError != null) ...[
              height5,
              Text(
                textFieldState.addressProofError!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ],
        );
      },
    );
  }
}