import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:packinn/core/constants/colors.dart';
import 'package:packinn/core/di/injection.dart';
import 'package:packinn/features/app/pages/chat/presentation/widgets/chat_app_bar_widget.dart';
import 'package:packinn/features/app/pages/chat/presentation/widgets/chat_message_section.dart';
import '../../../../../../core/constants/const.dart';
import '../providers/bloc/chat/chat_bloc.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({
    super.key,
    required this.chatId,
    required this.otherName,
    required this.otherPhoto,
  });

  final String chatId;
  final String otherName;
  final String otherPhoto;

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage(BuildContext context) {
    if (_messageController.text.trim().isNotEmpty) {
      context.read<ChatBloc>().add(SendMessageEvent(_messageController.text.trim()));
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatBloc = getIt<ChatBloc>(param1: widget.chatId)..add(LoadMessagesEvent());

    return BlocProvider.value(
      value: chatBloc,
      child: Builder(
        builder: (blocContext) {
          // Use blocContext instead of context to ensure correct scope
          return Scaffold(
            appBar: PreferredSize(
              preferredSize: Size(double.infinity, height * 0.077),
              child: ChatAppBarWidget(
                title: widget.otherName,
                photoUrl: widget.otherPhoto,
              ),
            ),
            body: Column(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.grey[50],
                    child: BlocBuilder<ChatBloc, ChatState>(
                      builder: (context, state) {
                        if (state is ChatLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (state is ChatLoaded) {
                          return ListView.separated(
                            padding: EdgeInsets.all(padding),
                            itemCount: state.messages.length,
                            reverse: true,
                            itemBuilder: (context, index) {
                              final message = state.messages[index];
                              final currentUid = FirebaseAuth.instance.currentUser!.uid;
                              final isMe = message.senderId == currentUid;
                              return ChatMessageSection(message: message, isMe: isMe);
                            },
                            separatorBuilder: (context, index) => height10,
                          );
                        } else if (state is ChatError) {
                          return Center(child: Text(state.message));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, -1),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: TextField(
                            controller: _messageController,
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                            ),
                            onSubmitted: (_) => _sendMessage(blocContext),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: IconButton(
                          onPressed: () => _sendMessage(blocContext),
                          icon: const Icon(
                            Icons.send,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}