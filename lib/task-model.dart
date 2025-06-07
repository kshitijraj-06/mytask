class Task {
  String id;  // Add ID for notification cancellation
  String title;
  bool isDone;
  int? notificationId;  // Store notification ID

  Task({
    String? id,
    required this.title,
    this.isDone = false,
    this.notificationId,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isDone': isDone,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'],
      isDone: map['isDone'],
    );
  }
}