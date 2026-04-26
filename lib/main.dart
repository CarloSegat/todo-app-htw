import 'package:flutter/material.dart';

class Todo {
  Todo(this.title, {this.done = false});

  final String title;
  final bool done;

  Todo toggle() => Todo(title, done: !done);
}

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});
  
  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final List<Todo> _todos = [];

  void _add(String title) => setState(() => _todos.add(Todo(title)));
  void _toggle(int i) => setState(() => _todos[i] = _todos[i].toggle());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: _todos.length,
        itemBuilder: (_, i) {
          final t = _todos[i];
          return CheckboxListTile(
            value: t.done,
            title: Text(t.title),
            onChanged: (_) => _toggle(i),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _add('Task ${_todos.length + 1}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: TodoListPage()),
);
