import 'package:flutter/material.dart';
import 'package:packinn/features/app/pages/chat/presentation/widgets/chat_app_bar_widget.dart';

import '../../../../../../core/constants/const.dart';
import '../widgets/chat_message_section.dart';

class IndividualChatScreen extends StatefulWidget {
  const IndividualChatScreen({super.key});

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Message> _messages = [
    Message(
      text: "Hey there! How are you doing?",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Message(
      text: "I'm doing great! Thanks for asking. How about you?",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 45)),
    ),
    Message(
      text: "I'm good too! Just working on some new features for the app",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    Message(
      text: "That sounds exciting! Can you tell me more about it?",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Message(
      text: "Sure! We're adding a new chat feature with real-time messaging",
      isMe: false,
      timestamp: DateTime.now().subtract(const Duration(minutes: 30)),
    ),
    Message(
      text: "Wow, that's amazing! I can't wait to try it out 😊",
      isMe: true,
      timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  void _sendMessage() {
    if (_messageController.text.trim().isNotEmpty) {
      setState(() {
        _messages.add(
          Message(
            text: _messageController.text.trim(),
            isMe: true,
            timestamp: DateTime.now(),
          ),
        );
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ChatAppBarWidget(title: 'Azeem ali'),
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: ListView.separated(
                padding: EdgeInsets.all(padding),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatMessageSection(message: message);
                },
                separatorBuilder: (context, index) => height10,
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
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: IconButton(
                    onPressed: _sendMessage,
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
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}

class Message {
  final String text;
  final bool isMe;
  final DateTime timestamp;

  Message({
    required this.text,
    required this.isMe,
    required this.timestamp,
  });
}

