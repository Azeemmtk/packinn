import 'package:flutter/material.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/const.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import 'individual_chat_screen.dart';

class AllChatScreen extends StatelessWidget {
  const AllChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBarWidget(title: 'Chat'),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => IndividualChatScreen(),
                          ));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(padding),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 23,
                            backgroundImage: NetworkImage(
                              'https://lh3.googleusercontent.com/aida-public/AB6AXuCV2BT4s-9VHuSPY0hF-wXQMqcHzjl76lbXSVv_vE0XLm1gsNZI5oNbo0-8QH4PKU91PHAolqn_CcwBb389vu7vQYqqBUOUMhXqsShZWO31BlMz7CvnOCaXCFFWbJdzpAY7t-LuAua5C7QdIlE4szqdRZHLk0eRRegTfrRdcPTQ0zwMT7Qg_H9qDgH_1LkagoKJh-jg0IZdNFyEXFbbMHhdMebFNrRl4c6kvzqEbHXX0LCWv695yNAC_PLfzrnCiImB4jU7LZ0d_FLg',
                            ),
                          ),
                          width10,
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Azeem ali',
                                style: TextStyle(
                                    fontSize: 18, color: headingTextColor),
                              ),
                              Text(
                                'okeeeey....',
                                style: TextStyle(fontSize: 15),
                              ),
                            ],
                          ),
                          Spacer(),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Just',
                              ),
                              Text(
                                'Now',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: 10),
          )
        ],
      ),
    );
  }
}
