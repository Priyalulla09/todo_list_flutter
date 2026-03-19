// lib/cubit/todo_cubit.dart

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../models/todo_model.dart';
import 'todo_state.dart';

class TodoCubit extends Cubit<TodoState> {
  TodoCubit() : super(const TodoState());

  final _uuid = const Uuid();

  void addTodo(String title, Priority priority) {
    if (title.trim().isEmpty) return;
    final newTodo = Todo(
      id: _uuid.v4(),
      title: title.trim(),
      priority: priority,
    );
    emit(TodoState(todos: [...state.todos, newTodo], filter: state.filter));
  }

  void toggleTodo(String id) {
    final updatedTodos = state.todos.map((todo) {
      return todo.id == id
          ? todo.copyWith(isCompleted: !todo.isCompleted)
          : todo;
    }).toList();
    emit(TodoState(todos: updatedTodos, filter: state.filter));
  }

  void deleteTodo(String id) {
    final updatedTodos =
    state.todos.where((todo) => todo.id != id).toList();
    emit(TodoState(todos: updatedTodos, filter: state.filter));
  }

  void setFilter(TodoFilter filter) {
    emit(TodoState(todos: state.todos, filter: filter));
  }
}
