import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'todos_scope.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final scope = TodosScope.of(context);
    final todos = scope.todos;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart),
            onPressed: () => context.go('/stats'),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (_, i) {
          final t = todos[i];
          return Dismissible(
            key: ValueKey(t.id),
            direction: DismissDirection.endToStart,
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            onDismissed: (_) => scope.delete(t.id),
            child: ListTile(
              leading: Checkbox(
                value: t.done,
                onChanged: (_) => scope.toggle(t.id),
              ),
              title: Text(t.title),
              onTap: () => context.go('/task/${t.id}'),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final controller = TextEditingController();

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
                      scope.add(controller.text);
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
