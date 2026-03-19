// lib/models/todo_model.dart

enum Priority { high, medium, low }

class Todo {
  final String id;
  final String title;
  final bool isCompleted;
  final Priority priority;

  const Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = Priority.medium,
  });

  Todo copyWith({
    String? title,
    bool? isCompleted,
    Priority? priority,
  }) {
    return Todo(
      id: id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      priority: priority ?? this.priority,
    );
  }
}