import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

class BuildBottomNavigationBar extends StatelessWidget {
  const BuildBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(Icons.home, 'Home', true),
          _buildBottomNavItem(Icons.search, 'Search', false),
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(16),
            child: const Icon(
              Icons.meeting_room,
              color: Colors.white,
              size: 24,
            ),
          ),
          _buildBottomNavItem(Icons.account_balance_wallet, 'Wallet', false),
          _buildBottomNavItem(Icons.account_circle, 'Account', false),
        ],
      ),
    );
  }
}
Widget _buildBottomNavItem(IconData icon, String label, bool isActive) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: isActive ? secondaryMain : Colors.grey[500],
        size: 24,
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: TextStyle(
          color: isActive ? secondaryMain : Colors.grey[500],
          fontSize: 12,
        ),
      ),
    ],
  );
}