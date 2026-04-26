import 'package:flutter/material.dart';

import 'todo.dart';
import 'todo_list_page.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<Todo> _todos = [];

  void _add(String title) => setState(() => _todos.add(Todo(title)));
  void _toggle(int i) => setState(() => _todos[i] = _todos[i].toggle());
  void _delete(int i) => setState(() => _todos.removeAt(i));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TodoListPage(
        todos: _todos,
        onAdd: _add,
        onToggle: _toggle,
        onDelete: _delete,
      ),
    );
  }
}

void main() => runApp(const TodoApp());
