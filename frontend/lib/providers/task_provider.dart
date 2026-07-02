import 'package:flutter/material.dart';

import '../models/task.dart';
import '../services/task_service.dart';

class TaskProvider extends ChangeNotifier {
  final List<TaskModel> _tasks = [];

  bool _isLoading = false;

  List<TaskModel> get tasks => _tasks;

  bool get isLoading => _isLoading;

  Future<bool> addTask({
    required String executiveId,
    required String title,
    required String description,
    required int dueMinutes,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final task = await TaskService.instance.addTask(
        executiveId: executiveId,
        title: title,
        description: description,
        dueMinutes: dueMinutes,
      );

      _tasks.add(task);

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
    _tasks.clear();
    notifyListeners();
  }
}