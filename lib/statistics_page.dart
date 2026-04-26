import 'package:flutter/material.dart';

import 'todos_scope.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todos = TodosScope.of(context).todos;
    final total = todos.length;
    final done = todos.where((t) => t.done).length;
    final percent = total == 0 ? 0 : done / total * 100;

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
