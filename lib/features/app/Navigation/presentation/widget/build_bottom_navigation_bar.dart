import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/colors.dart';
import '../../cubit/bottom_nav_cubit.dart';

class BuildBottomNavigationBar extends StatelessWidget {
  const BuildBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    final currentItem = context.watch<BottomNavCubit>().state;
    final cubit = context.read<BottomNavCubit>();

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
          _buildBottomNavItem(
            icon: Icons.home,
            label: 'Home',
            isActive: currentItem == BottomNavItem.home,
            onTap: () => cubit.selectItem(BottomNavItem.home),
          ),
          _buildBottomNavItem(
            icon: Icons.search,
            label: 'Search',
            isActive: currentItem == BottomNavItem.search,
            onTap: () => cubit.selectItem(BottomNavItem.search),
          ),
          GestureDetector(
            onTap: () => cubit.selectItem(BottomNavItem.myRoom),
            child: Container(
              decoration: BoxDecoration(
                color: currentItem == BottomNavItem.myRoom ? secondaryMain : mainColor,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(16),
              child: Icon(
                Icons.meeting_room,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          _buildBottomNavItem(
            icon: Icons.account_balance_wallet,
            label: 'Wallet',
            isActive: currentItem == BottomNavItem.wallet,
            onTap: () => cubit.selectItem(BottomNavItem.wallet),
          ),
          _buildBottomNavItem(
            icon: Icons.account_circle,
            label: 'Account',
            isActive: currentItem == BottomNavItem.account,
            onTap: () => cubit.selectItem(BottomNavItem.account),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
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
      ),
    );
  }
}
