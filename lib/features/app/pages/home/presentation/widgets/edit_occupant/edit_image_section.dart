import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/services/image_picker_service.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/bloc/add_cooupant/add_occupant_bloc.dart';
import 'package:packinn/features/app/pages/home/presentation/provider/cubit/occupant_field_cubit.dart';
import 'package:packinn/features/app/pages/home/presentation/widgets/confirm_booking/image_view_dialog.dart';

class EditImageSection extends StatelessWidget {
  final AddOccupantBloc addOccupantBloc;
  final OccupantFieldCubit textFieldCubit;
  final AddOccupantLoaded currentState;

  const EditImageSection({
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
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(profileImage: image);
                      addOccupantBloc.add(
                        UpdateOccupantEvent(
                          name: textFieldState.name,
                          phone: textFieldState.phone,
                          age: int.tryParse(textFieldState.age),
                          guardianName: textFieldState.guardianName,
                          guardianPhone: textFieldState.guardianPhone,
                          guardianRelation: textFieldState.guardianRelation,
                          profileImage: image,
                          addressProof: currentState.addressProof,
                          profileImageUrl: null,
                          addressProofUrl: currentState.addressProofUrl,
                        ),
                      );
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text('Occupant Image'),
                ),
                if (currentState.profileImage != null || currentState.profileImageUrl != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(
                          image: currentState.profileImage,
                          imageUrl: currentState.profileImageUrl,
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: currentState.profileImage != null
                              ? FileImage(currentState.profileImage!)
                              : NetworkImage(currentState.profileImageUrl!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(idProof: image);
                      addOccupantBloc.add(
                        UpdateOccupantEvent(
                          name: textFieldState.name,
                          phone: textFieldState.phone,
                          age: int.tryParse(textFieldState.age),
                          guardianName: textFieldState.guardianName,
                          guardianPhone: textFieldState.guardianPhone,
                          guardianRelation: textFieldState.guardianRelation,
                          idProof: image,
                          addressProof: currentState.addressProof,
                          idProofUrl: null, // Clear URL when new image is uploaded
                          addressProofUrl: currentState.addressProofUrl,
                        ),
                      );
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text(
                      currentState.idProof != null || currentState.idProofUrl != null
                          ? 'Replace ID Proof'
                          : 'Upload ID Proof'),
                ),
                if (currentState.idProof != null || currentState.idProofUrl != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(
                          image: currentState.idProof,
                          imageUrl: currentState.idProofUrl,
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: currentState.idProof != null
                              ? FileImage(currentState.idProof!)
                              : NetworkImage(currentState.idProofUrl!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (textFieldState.idProofError != null) ...[
              height5,
              Text(
                textFieldState.idProofError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height10,
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final image = await getIt<ImagePickerService>().showImageSourceDialog(context);
                    if (image != null) {
                      textFieldCubit.updateField(addressProof: image);
                      addOccupantBloc.add(
                        UpdateOccupantEvent(
                          name: textFieldState.name,
                          phone: textFieldState.phone,
                          age: int.tryParse(textFieldState.age),
                          guardianName: textFieldState.guardianName,
                          guardianPhone: textFieldState.guardianPhone,
                          guardianRelation: textFieldState.guardianRelation,
                          idProof: currentState.idProof,
                          addressProof: image,
                          idProofUrl: currentState.idProofUrl,
                          addressProofUrl: null, // Clear URL when new image is uploaded
                        ),
                      );
                      textFieldCubit.validateFields(isSubmitted: false);
                    }
                  },
                  child: Text(
                      currentState.addressProof != null || currentState.addressProofUrl != null
                          ? 'Replace Address Proof'
                          : 'Upload Address Proof'),
                ),
                if (currentState.addressProof != null || currentState.addressProofUrl != null) ...[
                  width10,
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => ImageViewDialog(
                          image: currentState.addressProof,
                          imageUrl: currentState.addressProofUrl,
                        ),
                      );
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: currentState.addressProof != null
                              ? FileImage(currentState.addressProof!)
                              : NetworkImage(currentState.addressProofUrl!) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            if (textFieldState.addressProofError != null) ...[
              height5,
              Text(
                textFieldState.addressProofError!,
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
            height20,
          ],
        );
      },
    );
  }
}