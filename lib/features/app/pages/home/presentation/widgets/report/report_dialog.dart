import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/core/widgets/custom_green_button_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../../../../core/services/image_picker_service.dart';
import '../../../domain/entity/reposrt_entity.dart';
import '../../provider/bloc/report/report_bloc.dart';

class ReportDialog extends StatefulWidget {
  final String hostelId;
  final String ownerId;

  const ReportDialog({
    super.key,
    required this.hostelId,
    required this.ownerId,
  });

  @override
  State<ReportDialog> createState() => _ReportDialogState();
}

class _ReportDialogState extends State<ReportDialog> {
  final TextEditingController _messageController = TextEditingController();
  File? _selectedImage;
  final ImagePickerService _imagePickerService = getIt<ImagePickerService>();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<ReportBloc>(),
      child: BlocConsumer<ReportBloc, ReportState>(
        listener: (context, state) {
          if (state is ReportSubmitted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Report submitted successfully')),
            );
          } else if (state is ReportError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          return AlertDialog(
            title: const Text('Submit Report'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      labelText: 'Report Message',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 10),
                  if (_selectedImage != null)
                    Image.file(
                      _selectedImage!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  TextButton(
                    onPressed: () async {
                      final image = await _imagePickerService.showImageSourceDialog(context);
                      if (image != null) {
                        setState(() {
                          _selectedImage = image;
                        });
                      }
                    },
                    child: const Text('Attach Photo'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              CustomGreenButtonWidget(
                name: state is ReportLoading ? 'Submitting...' : 'Submit',
                onPressed: state is ReportLoading
                    ? null
                    : () {
                  final userId = FirebaseAuth.instance.currentUser?.uid;
                  if (userId == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please log in to submit a report')),
                    );
                    return;
                  }
                  if (_messageController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter a report message')),
                    );
                    return;
                  }
                  final report = ReportEntity(
                    message: _messageController.text,
                    imageUrl: _selectedImage?.path,
                    senderId: userId,
                    hostelId: widget.hostelId,
                    ownerId: widget.ownerId,
                    createdAt: DateTime.now(),
                    status: 'pending',
                  );
                  context.read<ReportBloc>().add(SubmitReportEvent(report: report));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}