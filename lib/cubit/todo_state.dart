// lib/cubit/todo_state.dart

import 'package:equatable/equatable.dart';
import '../models/todo_model.dart';

enum TodoFilter { all, active, completed }

class TodoState extends Equatable {
  final List<Todo> todos;
  final TodoFilter filter;

  const TodoState({
    this.todos = const [],
    this.filter = TodoFilter.all,
  });

  List<Todo> get filteredTodos {
    switch (filter) {
      case TodoFilter.active:
        return todos.where((t) => !t.isCompleted).toList();
      case TodoFilter.completed:
        return todos.where((t) => t.isCompleted).toList();
      case TodoFilter.all:
        return todos;
    }
  }

  int get completedCount => todos.where((t) => t.isCompleted).length;

  @override
  List<Object> get props => [todos, filter];
}