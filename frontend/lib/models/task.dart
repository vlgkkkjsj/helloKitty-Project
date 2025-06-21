class Task {
  final String title;
  final String description;
  final String dueDate;
  final String priority;
  final bool isCompleted;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? 'Medium',
      isCompleted: json['is_completed'] ?? false ,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
      'is_completed': isCompleted,
    };
  }
}
