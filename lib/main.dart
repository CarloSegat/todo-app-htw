import 'package:flutter/material.dart';

class Todo {
  Todo(this.title, {this.done = false});

  final String title;
  final bool done;

  Todo toggle() => Todo(title, done: !done);
}

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

class TodoListPage extends StatelessWidget {
  const TodoListPage({
    super.key,
    required this.todos,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  final List<Todo> todos;
  final void Function(String title) onAdd;
  final void Function(int index) onToggle;
  final void Function(int index) onDelete;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => Navigator.of(context).push(
              // A modal route that replaces the entire screen. 
              // Also takes care of animating the transition.

             // Aach route it's its own Scaffold. 
             // Navigator pushes full-screen route on top, replacing everything.
             // there is no diffing, must rebuild everythingx
              MaterialPageRoute(
                builder: (_) => StatisticsPage(todos: todos),
              ),
            ),
          ),
        ],
      ),
      // ListView constructor is not called directly,
      // the .builder will smartly skip items that are not visible
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, i) {
          final t = todos[i];
          return Dismissible(
            key: ValueKey(t.title),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => onDelete(i),
            child: CheckboxListTile(
              value: t.done,
              title: Text(t.title),
              onChanged: (_) => onToggle(i),
            ),
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
                      onAdd(controller.text);
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

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key, required this.todos});

  final List<Todo> todos;

  @override
  Widget build(BuildContext context) {
    final total = todos.length;
    final done = todos.where((t) => t.done).length;
    final percent = total == 0 ? 0 : done / total * 100;

    // where does the back arrow come from?
    // AppBar auto-adds it when Navigator.canPop(context) is true
    // (which is the case because we pushed the statistics route)
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todo Statistics',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total: $total', style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Text(
              'Completed: ${percent.toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(const TodoApp());
