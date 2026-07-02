import 'api_service.dart';

class ChatService {
  Future<String> sendMessage(String userId, String query) async {
    final response = await ApiService.instance.post(
      "/chat/query",
      data: {
        "executive_id": userId,
        "query": query,
      },
    );

    return response.data["digital_twin_response"];
  }

  Future<void> clearChat(String userId) async {
    await ApiService.instance.delete("/reset/history/$userId");
  }
}