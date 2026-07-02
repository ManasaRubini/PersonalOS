import '../models/memory.dart';
import 'api_service.dart';

class MemoryService {
  MemoryService._();

  static final instance = MemoryService._();

  Future<MemoryModel> addMemory({
    required String executiveId,
    required String title,
    required String content,
    required String category,
  }) async {
    final response = await ApiService.instance.post(
      "/memory/add",
      data: {
        "executive_id": executiveId,
        "title": title,
        "content": content,
        "category": category,
      },
    );

    return MemoryModel(
      id: response.data["memory_id"],
      title: title,
      content: content,
      category: category,
    );
  }

  Future<void> loadMemories(String executiveId) async {
    // Will connect after
    // GET /memory/{executive_id}
  }
}