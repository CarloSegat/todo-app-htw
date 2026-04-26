import 'package:flutter/material.dart';

import 'todo_list_page.dart';
import 'todos_scope.dart';

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const TodosScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: TodoListPage(),
      ),
    );
  }
}

void main() => runApp(const TodoApp());
