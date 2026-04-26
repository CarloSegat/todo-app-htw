import 'package:flutter/material.dart';

class Todo {
  Todo(this.title, {this.done = false});
  final String title;
  final bool done;
  Todo toggle() => Todo(title, done: !done);
}

class TodosHost extends StatefulWidget {
  const TodosHost({super.key, required this.child});
  final Widget child;
  @override
  State<TodosHost> createState() => _TodosHostState();
}

class _TodosHostState extends State<TodosHost> {
  List<Todo> _todos = [];

  void _add(String title) => setState(() => _todos = [..._todos, Todo(title)]);

  void _toggle(int i) => setState(() {
    final next = [..._todos]; // copying so `todos != old.todos` will be true
    next[i] = next[i].toggle();
    _todos = next;
  });

  @override
  Widget build(BuildContext context) =>
      TodoListPage(todos: _todos, onAdd: _add, onToggle: _toggle);
}

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key, this.todos, this.onAdd, this.onToggle});

  final dynamic todos;
  final dynamic onAdd;
  final dynamic onToggle;

  @override
  Widget build(BuildContext context) {
    // final scope = TodosScope.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, i) {
          final t = todos[i];
          return CheckboxListTile(
            value: t.done,
            title: Text(t.title),
            onChanged: (_) => onToggle(i),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => onAdd('Task ${todos.length + 1}'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() => runApp(
  const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: TodosHost(child: TodoListPage()),
  ),
);
