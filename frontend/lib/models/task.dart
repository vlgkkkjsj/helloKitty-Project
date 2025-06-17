class Task {
  final String title;
  final String description;
  final String dueDate;
  final String priority;

  Task({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      priority: json['priority'] ?? 'Medium',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'priority': priority,
    };
  }
}
