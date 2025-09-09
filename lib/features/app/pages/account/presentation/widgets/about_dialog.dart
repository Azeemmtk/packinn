import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'About Hostel Booking App',
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
              'The Hostel Booking App connects users with hostels, making it easy to find and book accommodations. Key features include:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            const Text(
              '- **Browse Hostels**: Search for hostels by location, amenities, or price.\n'
                  '- **Book Rooms**: View available rooms and secure your booking in a few taps.\n'
                  '- **Secure Payments**: Pay directly through the app with trusted payment methods.\n'
                  '- **Map Integration**: Find hostels on an interactive map for easy navigation.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Developed by: HostelApp Team\n'
                  'Contact: support@hostelapp.com',
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