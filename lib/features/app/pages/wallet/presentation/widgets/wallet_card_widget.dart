import 'package:flutter/material.dart';
import 'package:packinn/core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../screens/payment_screen.dart';

class WalletCardWidget extends StatelessWidget {

  const WalletCardWidget({super.key, });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentScreen(occupantId: '',),));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: Image.network(
                imagePlaceHolder,
                width: width * 0.35,
                height: height * 0.14,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.network(
                  imagePlaceHolder,
                  width: width * 0.35,
                  height: height * 0.14,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Summit hostel',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      width5,
                      Container()
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vadakara, calicut, kerala',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RENT - 500 /MONTH',
                    style: const TextStyle(
                      color: mainColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '4.5',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}