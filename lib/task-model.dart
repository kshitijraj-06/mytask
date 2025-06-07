class Task {
  String id;
  String title;
  bool isDone;
  int? notificationId;
  int priority;

  Task({
    String? id,
    required this.title,
    this.isDone = false,
    this.notificationId,
    this.priority = 3,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'title': title,
      'isDone': isDone,
      'priority': priority,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'],
      title: map['title'],
      isDone: map['isDone'],
      priority: map['priority'] ?? 3,
    );
  }
}