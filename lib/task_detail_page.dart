import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'todos_scope.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key, required this.id});

  final String id;

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  TextEditingController? _description;

  @override
  void didChangeDependencies() {
    // also called once after init
    super.didChangeDependencies();
    if (_description == null) {
      // notice how the _TaskDetailPageState does not hold a reference to the Todo
      // instead it grabs it from the scope when it needs it 
      final todo = TodosScope.of(context).findById(widget.id);
      if (todo != null) {
        _description = TextEditingController(text: todo.description);
      }
    }
  }

  @override
  void dispose() {
    _description?.dispose();
    super.dispose();
  }

  Future<void> _share(BuildContext context) async {
    final link = 'todoapp://task/${widget.id}';
    await Clipboard.setData(ClipboardData(text: link));
    if (! context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Link copied')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scope = TodosScope.of(context);
    final todo = scope.findById(widget.id);

    if (todo == null) {
      return const Scaffold(
        body: Center(child: Text('Task not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Task Detail')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Checkbox(
                value: todo.done,
                onChanged: (_) => scope.toggle(todo.id),
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
            onChanged: (text) =>
                scope.update(todo.id, todo.copyWith(description: text)),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            icon: const Icon(Icons.share),
            label: const Text('Share (deeplink)'),
            onPressed: () => _share(context),
          ),
        ],
      ),
    );
  }
}
