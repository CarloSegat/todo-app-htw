import 'package:flutter/material.dart';

import 'statistics_page.dart';
import 'todo.dart';

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
              MaterialPageRoute(builder: (_) => StatisticsPage(todos: todos)),
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
