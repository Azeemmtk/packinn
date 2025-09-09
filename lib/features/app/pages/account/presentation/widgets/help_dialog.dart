import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';

class HelpDialog extends StatelessWidget {
  const HelpDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Help',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
          color: headingTextColor,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome to the Hostel Booking App! Here’s how to use the app to find and book your ideal hostel:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '1. Browsing Hostels:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              '- Use the search feature to find hostels by location, name, or facilities.\n'
                  '- View hostel details, including photos, descriptions, and available rooms.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              '2. Booking Rooms:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              '- Select a hostel and choose an available room that suits your needs.\n'
                  '- Confirm your booking by providing required details and submitting the request.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              '3. Making Payments:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              '- Pay for your booking securely through the app using supported payment methods.\n'
                  '- View your payment history in the account section.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              '4. Finding Hostels on Map:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Text(
              '- Use the map feature to locate hostels near your desired area.\n'
                  '- Tap on a hostel pin to view details and book directly.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Need assistance? Contact support at support@hostelapp.com.',
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Close',
            style: TextStyle(color: mainColor),
          ),
        ),
      ],
    );
  }
}