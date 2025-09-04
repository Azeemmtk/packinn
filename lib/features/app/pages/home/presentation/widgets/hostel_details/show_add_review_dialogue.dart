import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../../core/utils/enums.dart';
import '../../../domain/entity/review_entity.dart';
import '../../provider/bloc/review/review_bloc.dart';

void showAddReviewDialog(BuildContext parentContext, String hostelId) {
  int rating = 0;
  TextEditingController reviewController = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  String userName = 'Anonymous';
  String? userImageUrl;

  // Fetch user details
  if (user != null) {
    FirebaseFirestore.instance.collection('users').doc(user.uid).get().then((doc) {
      if (doc.exists) {
        final data = doc.data()!;
        userName = data['name'] ?? user.displayName ?? 'Anonymous';
        userImageUrl = data['profileImageUrl'] ?? user.photoURL;
        // Trigger rebuild of dialog
        (parentContext as Element).markNeedsBuild();
      }
    });
  }

  showDialog(
    context: parentContext,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Add Review & Rating'),
      content: StatefulBuilder(
        builder: (context, setState) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow[700],
                  ),
                  onPressed: () {
                    setState(() {
                      rating = index + 1;
                    });
                  },
                );
              }),
            ),
            height10,
            TextField(
              controller: reviewController,
              decoration: const InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (rating > 0 && reviewController.text.isNotEmpty && user != null) {
              final review = ReviewEntity(
                id: const Uuid().v4(),
                hostelId: hostelId,
                userId: user.uid,
                userName: userName,
                userImageUrl: userImageUrl,
                rating: rating,
                comment: reviewController.text,
                createdAt: DateTime.now(),
                status: Status.active,
              );
              parentContext.read<ReviewBloc>().add(AddReview(review));
              Navigator.pop(dialogContext);
            }
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
}