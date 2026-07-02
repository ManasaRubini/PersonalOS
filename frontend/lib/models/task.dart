class TaskModel {
  final String id;
  final String title;
  final String description;
  final DateTime? dueDate;
  final bool isCompleted;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    this.dueDate,
    this.isCompleted = false,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json["id"]?.toString() ?? "",
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      dueDate: json["due_date"] != null
          ? DateTime.tryParse(json["due_date"])
          : null,
      isCompleted: json["is_completed"] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "due_date": dueDate?.toIso8601String(),
      "is_completed": isCompleted,
    };
  }
}