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
      // ListView constructor is not called directly, 
      // the .builder will smartly skip items that are not visible
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
        onPressed: () async {
          // controller holds the value of the text (source of truth)
          // it also holds more stuff like cursor position and composing region (for e.g. thai)
          final controller = TextEditingController();

          // showDialog implements Material-style pop up
          // <void> emans no return value when popup is closed
          await showDialog<void>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Todo'),
              content: TextField(
                controller: controller,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Enter todo text'),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      _add(controller.text);
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

void main() => runApp(
  const MaterialApp(debugShowCheckedModeBanner: false, home: TodoListPage()),
);
