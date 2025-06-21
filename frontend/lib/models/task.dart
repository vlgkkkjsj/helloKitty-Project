class Task {
  final int id; // <-- ESTE CAMPO É OBRIGATÓRIO
  final String title;
  final String description;
  final String? dueDate;
  final String priority;
  final bool isCompleted;
  final String user;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    required this.isCompleted,
    required this.user,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'], // <-- Certifique-se que o campo 'id' vem do JSON
      title: json['title'],
      description: json['description'] ?? '',
      dueDate: json['due_date'],
      priority: json['priority'],
      isCompleted: json['is_completed'],
      user: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'due_date': dueDate,
      'priority': priority,
      'is_completed': isCompleted,
      'user': user,
    };
  }
}
