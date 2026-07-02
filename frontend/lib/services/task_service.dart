import '../models/task.dart';
import 'api_service.dart';

class TaskService {
  TaskService._();

  static final instance = TaskService._();

  Future<TaskModel> addTask({
    required String executiveId,
    required String title,
    required String description,
    required int dueMinutes,
  }) async {
    final response = await ApiService.instance.post(
      "/tasks/add",
      data: {
        "executive_id": executiveId,
        "title": title,
        "description": description,
        "due_minutes_from_now": dueMinutes,
      },
    );

    return TaskModel(
      id: response.data["task_id"],
      title: title,
      description: description,
      dueDate: DateTime.now().add(
        Duration(minutes: dueMinutes),
      ),
      isCompleted: false,
    );
  }

  Future<void> loadTasks(String executiveId) async {
    // We'll connect this after adding
    // GET /tasks/{executive_id}
  }
}