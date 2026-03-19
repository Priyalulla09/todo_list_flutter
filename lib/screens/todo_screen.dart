// lib/screens/todo_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/todo_cubit.dart';
import '../cubit/todo_state.dart';
import '../models/todo_model.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({super.key});

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final TextEditingController _controller = TextEditingController();
  Priority _selectedPriority = Priority.medium;

  static const _bg = Color(0xFF0A0A0F);
  static const _surface = Color(0xFF13131A);
  static const _card = Color(0xFF1C1C26);
  static const _accent = Color(0xFF00C9A7);
  static const _textPrimary = Color(0xFFF0F0F5);
  static const _textMuted = Color(0xFF6B6B80);

  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.high:   return const Color(0xFFFF4D6D);
      case Priority.medium: return const Color(0xFFFFB800);
      case Priority.low:    return const Color(0xFF00C9A7);
    }
  }

  String _priorityLabel(Priority p) {
    switch (p) {
      case Priority.high:   return 'High';
      case Priority.medium: return 'Med';
      case Priority.low:    return 'Low';
    }
  }

  void _addTask() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    context.read<TodoCubit>().addTodo(text, _selectedPriority);
    _controller.clear();
    setState(() => _selectedPriority = Priority.medium);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildInputArea(),
            _buildFilterTabs(),
            const SizedBox(height: 8),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        final total = state.todos.length;
        final done = state.completedCount;
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: _accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'MY TASKS',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                total == 0
                    ? 'Nothing here yet'
                    : '$done of $total completed',
                style: const TextStyle(
                  color: _textPrimary,
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 14),
              if (total > 0)
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: total == 0 ? 0 : done / total,
                    backgroundColor: _surface,
                    valueColor:
                    const AlwaysStoppedAnimation<Color>(_accent),
                    minHeight: 4,
                  ),
                ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A38), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: _textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    hintText: 'What needs to be done?',
                    hintStyle: TextStyle(color: _textMuted, fontSize: 15),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  onSubmitted: (_) => _addTask(),
                ),
              ),
              GestureDetector(
                onTap: _addTask,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: _accent,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add,
                      color: Color(0xFF0A0A0F), size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Priority selector
          Row(
            children: Priority.values.map((p) {
              final selected = _selectedPriority == p;
              return GestureDetector(
                onTap: () => setState(() => _selectedPriority = p),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected
                        ? _priorityColor(p).withOpacity(0.15)
                        : _card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selected
                          ? _priorityColor(p)
                          : Colors.transparent,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: _priorityColor(p),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _priorityLabel(p),
                        style: TextStyle(
                          color: selected
                              ? _priorityColor(p)
                              : _textMuted,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabs() {
    return BlocBuilder<TodoCubit, TodoState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: TodoFilter.values.map((filter) {
              final selected = state.filter == filter;
              final label = filter.name[0].toUpperCase() +
                  filter.name.substring(1);
              return GestureDetector(
                onTap: () =>
                    context.read<TodoCubit>().setFilter(filter),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? _accent : _surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      color: selected
                          ? const Color(0xFF0A0A0F)
                          : _textMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTaskList() {
    return Expanded(
      child: BlocBuilder<TodoCubit, TodoState>(
        builder: (context, state) {
          final todos = state.filteredTodos;

          if (todos.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_outline,
                      color: _textMuted.withOpacity(0.4), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    state.filter == TodoFilter.completed
                        ? 'Nothing completed yet'
                        : 'All clear!',
                    style: const TextStyle(
                        color: _textMuted, fontSize: 15),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return _buildTaskCard(todo);
            },
          );
        },
      ),
    );
  }

  Widget _buildTaskCard(Todo todo) {
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => context.read<TodoCubit>().deleteTodo(todo.id),
      background: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFF4D6D).withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: const Color(0xFFFF4D6D).withOpacity(0.3)),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete_outline,
            color: Color(0xFFFF4D6D), size: 22),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: _card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: todo.isCompleted
                ? Colors.transparent
                : _priorityColor(todo.priority).withOpacity(0.2),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          leading: GestureDetector(
            onTap: () => context.read<TodoCubit>().toggleTodo(todo.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: todo.isCompleted
                    ? _accent
                    : Colors.transparent,
                border: Border.all(
                  color: todo.isCompleted ? _accent : _textMuted,
                  width: 2,
                ),
              ),
              child: todo.isCompleted
                  ? const Icon(Icons.check,
                  size: 12, color: Color(0xFF0A0A0F))
                  : null,
            ),
          ),
          title: Text(
            todo.title,
            style: TextStyle(
              color: todo.isCompleted
                  ? _textMuted
                  : _textPrimary,
              fontSize: 15,
              decoration: todo.isCompleted
                  ? TextDecoration.lineThrough
                  : null,
              decorationColor: _textMuted,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: _priorityColor(todo.priority).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _priorityLabel(todo.priority),
                  style: TextStyle(
                    color: _priorityColor(todo.priority),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}