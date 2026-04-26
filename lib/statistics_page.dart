import 'package:flutter/material.dart';

import 'todo.dart';

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
