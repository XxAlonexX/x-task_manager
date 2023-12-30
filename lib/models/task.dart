class Task {
  final int id;
  final int userId;
  final String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false,
    this.userId = 1,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      userId: json['userId'],
      title: json['title'],
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }
}
