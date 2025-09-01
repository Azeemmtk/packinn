import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packinn/core/services/current_user.dart';

import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../screens/all_chat_screen.dart';

class ChatAppBarWidget extends StatelessWidget {
  const ChatAppBarWidget({
    super.key,
    required this.title,
    this.enableChat = false,
  });

  final String title;
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
                'https://lh3.googleusercontent.com/aida-public/AB6AXuCV2BT4s-9VHuSPY0hF-wXQMqcHzjl76lbXSVv_vE0XLm1gsNZI5oNbo0-8QH4PKU91PHAolqn_CcwBb389vu7vQYqqBUOUMhXqsShZWO31BlMz7CvnOCaXCFFWbJdzpAY7t-LuAua5C7QdIlE4szqdRZHLk0eRRegTfrRdcPTQ0zwMT7Qg_H9qDgH_1LkagoKJh-jg0IZdNFyEXFbbMHhdMebFNrRl4c6kvzqEbHXX0LCWv695yNAC_PLfzrnCiImB4jU7LZ0d_FLg',
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
