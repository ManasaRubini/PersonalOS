import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/message_bubble.dart';
import '../../widgets/typing_indicator.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController scrollController = ScrollController();

  void scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (scrollController.hasClients) {
        scrollController.animateTo(
          scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final auth = context.read<AuthProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToBottom();
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("Digital Twin AI"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: chat.clear,
          )
        ],
      ),

      body: Column(
        children: [
          if (chat.lastMemoryContext != null)
            Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.purple.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "🧠 ${chat.lastMemoryContext}",
                style: const TextStyle(fontSize: 12),
              ),
            ),
          // CHAT LIST
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              padding: const EdgeInsets.all(12),
              itemCount: chat.messages.length,
              itemBuilder: (context, index) {
                final msg = chat.messages[index];

                return MessageBubble(
                  text: msg.content,
                  isUser: msg.role == "user",
                );
              },
            ),
          ),

          // TYPING INDICATOR
          if (chat.isLoading) const TypingIndicator(),

          // INPUT BOX
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Ask your Digital Twin...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final text = controller.text.trim();
                    if (text.isEmpty) return;

                    chat.sendMessage(
                      auth.currentUser!.userId,
                      text,
                    );

                    controller.clear();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}