import 'package:flutter/material.dart';

import '../models/memory.dart';
import '../services/memory_service.dart';

class MemoryProvider extends ChangeNotifier {
  final List<MemoryModel> _memories = [];

  bool _isLoading = false;

  List<MemoryModel> get memories => _memories;

  bool get isLoading => _isLoading;

  Future<bool> addMemory({
    required String executiveId,
    required String title,
    required String content,
    required String category,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final memory = await MemoryService.instance.addMemory(
        executiveId: executiveId,
        title: title,
        content: content,
        category: category,
      );

      _memories.add(memory);

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint(e.toString());
      return false;
    }
  }

  void clear() {
    _memories.clear();
    notifyListeners();
  }
}