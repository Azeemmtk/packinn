import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';

class ChatAppBarWidget extends StatelessWidget {
  const ChatAppBarWidget({
    super.key,
    required this.title,
    required this.photoUrl,
    this.enableChat = false,
  });

  final String title;
  final String photoUrl;
  final bool enableChat;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height * 0.12,
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(width * 0.1),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: height * 0.045, left: padding, right: padding, bottom: padding),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                size: 30,
              ),
            ),
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(
                photoUrl,
              ),
            ),
            width10,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF374151),
                  ),
                ),
                Text(
                  'online',
                  style: const TextStyle(
                    fontSize: 16,

                    // color: Color(0xFF374151),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
