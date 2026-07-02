class DashboardStats {
  final int tasks;
  final int completed;
  final int pending;
  final int memories;
  final int conversations;

  DashboardStats({
    required this.tasks,
    required this.completed,
    required this.pending,
    required this.memories,
    required this.conversations,
  });

  factory DashboardStats.fromJson(
      Map<String, dynamic> json) {
    return DashboardStats(
      tasks: json["tasks"],
      completed: json["completed"],
      pending: json["pending"],
      memories: json["memories"],
      conversations: json["conversations"],
    );
  }
}