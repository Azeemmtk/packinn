import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';

class TermsPolicyDialog extends StatelessWidget {
  const TermsPolicyDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Terms & Privacy Policy',
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
              'Terms of Use',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'By using the Hostel Booking App, you agree to the following terms:\n'
                  '- You are responsible for providing accurate information during booking and payment.\n'
                  '- Bookings are subject to hostel availability and owner confirmation.\n'
                  '- Payments made through the app are final, subject to the hostel’s refund policy.\n'
                  '- Any misuse of the app may result in account suspension.\n'
                  '- The HostelApp Team reserves the right to update these terms at any time.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Privacy Policy',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 5),
            const Text(
              'We prioritize your privacy and protect your data:\n'
                  '- **Data Collection**: We collect personal details (e.g., name, contact info), booking information, and payment data to facilitate your experience.\n'
                  '- **Data Use**: Your data is used to process bookings, payments, and provide map-based hostel searches. It is not shared with third parties except as required by law or for payment processing.\n'
                  '- **Data Security**: We use industry-standard security measures to protect your information, though no system is completely secure.\n'
                  '- **Contact**: For privacy concerns, email support@hostelapp.com.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 10),
            const Text(
              'Last Updated: September 9, 2025',
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