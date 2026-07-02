import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_service.dart';

class ChatProvider extends ChangeNotifier {
  final ChatService _service = ChatService();

  List<ChatMessage> messages = [];
  bool isLoading = false;
  String? lastMemoryContext;

Future<void> sendMessage(String userId, String text) async {
  messages.add(ChatMessage(role: "user", content: text));

  isLoading = true;
  lastMemoryContext = null;
  notifyListeners();

  try {
    final response = await _service.sendMessage(userId, text);

    // fake memory indicator (frontend simulation)
    lastMemoryContext = "Using semantic memory + chat history";

    messages.add(
      ChatMessage(role: "assistant", content: response),
    );
  } catch (e) {
    messages.add(
      ChatMessage(
        role: "assistant",
        content: "Error connecting to AI engine",
      ),
    );
  }

  isLoading = false;
  notifyListeners();
}

  void clear() {
    messages.clear();
    notifyListeners();
  }

  Future<void> clearChat(String userId) async {
    try {
      await _service.clearChat(userId);
      clear();
    } catch (e) {
      rethrow;
    }
  }
}