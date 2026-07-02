class MemoryModel {
  final String id;
  final String title;
  final String content;
  final String category;

  MemoryModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
  });

  factory MemoryModel.fromJson(Map<String, dynamic> json) {
    return MemoryModel(
      id: json["id"]?.toString() ?? "",
      title: json["title"] ?? "",
      content: json["content"] ?? "",
      category: json["category"] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "title": title,
      "content": content,
      "category": category,
    };
  }
}