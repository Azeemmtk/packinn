import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/constants/const.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/features/app/pages/chat/domain/entity/chat_entity.dart';
import 'package:packinn/features/app/pages/chat/presentation/screens/individual_chat_screen.dart';

import '../../../../../../core/utils/formate_time.dart';
import '../../../../../../core/widgets/custom_app_bar_widget.dart';
import '../providers/bloc/allchats/all_chat_bloc.dart';
import '../widgets/all_chat_card_widget.dart';

class AllChatScreen extends StatelessWidget {
  const AllChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AllChatBloc>()..add(LoadChatsEvent()),
      child: Scaffold(
        body: Column(
          children: [
            CustomAppBarWidget(title: 'Chat'),
            Expanded(
              child: BlocBuilder<AllChatBloc, AllChatsState>(
                builder: (context, state) {
                  if (state is AllChatsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AllChatsLoaded) {
                    if (state.chats.isEmpty) {
                      return const Center(child: Text('No chats available'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: state.chats.length,
                      itemBuilder: (context, index) {
                        final chat = state.chats[index];
                        final currentUid = FirebaseAuth.instance.currentUser!.uid;
                        final otherUid = chat.participants.firstWhere((id) => id != currentUid);
                        final otherName = chat.participantsInfo[otherUid]?['name'] ?? 'Unknown';
                        final otherPhoto = chat.participantsInfo[otherUid]?['photo'] ?? '';
                        final lastMessage = chat.lastMessage;
                        final time = formatTime(chat.lastTimestamp);

                        return AllChatCardWidget(chat: chat, otherName: otherName, otherPhoto: otherPhoto, lastMessage: lastMessage, time: time);
                      },
                    );
                  } else if (state is AllChatsError) {
                    return Center(child: Text('Error: ${state.message}'));
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

