import 'package:flutter/material.dart';

import 'todos_scope.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.index});

  final int index;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  // the value of this is lost when navigating out of the detail window
  TextEditingController? _description;

  // State class has a default initState method that is run once after lanucnhing the app
  // initState will call didChangeDependencies to setup the text controller
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_description == null) {
      final todos = TodosScope.of(context).todos;
      if (widget.index < todos.length) {
        _description = TextEditingController(
          text: todos[widget.index].description,
        );
      }
    }
  }

  // from initState we cannot access TodosScope.of
  // so we put the text controller initialization in the didChangeDependencies

  @override
  void dispose() {
    _description?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = TodosScope.of(context);
    final todo = scope.todos[widget.index];

    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Checkbox(
                value: todo.done,
                onChanged: (_) => scope.toggle(widget.index),
              ),
              Expanded(
                child: Text(
                  todo.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Created: ${todo.createdAt.toLocal()}'),
          const SizedBox(height: 16),
          TextField(
            controller: _description,
            maxLines: null,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            onChanged: (text) => scope.update(
              widget.index,
              todo.copyWith(description: text),
            ),
          ),
        ],
      ),
    );
  }
}
