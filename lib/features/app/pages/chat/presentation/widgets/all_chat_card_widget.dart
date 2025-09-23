import 'package:flutter/material.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../../domain/entity/chat_entity.dart';
import '../screens/individual_chat_screen.dart';

class AllChatCardWidget extends StatelessWidget {
  const AllChatCardWidget({
    super.key,
    required this.chat,
    required this.otherName,
    required this.otherPhoto,
    required this.lastMessage,
    required this.time,
  });

  final ChatEntity chat;
  final String otherName;
  final String otherPhoto;
  final String lastMessage;
  final String time;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => IndividualChatScreen(
              chatId: chat.id,
              otherName: otherName,
              otherPhoto: otherPhoto,
            ),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundImage: NetworkImage(otherPhoto),
            ),
            width10,
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  otherName,
                  style: TextStyle(fontSize: 18, color: headingTextColor),
                ),
                SizedBox(
                  width: width * 0.62,
                  child: Text(
                    lastMessage,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            Text(time),
          ],
        ),
      ),
    );
  }
}