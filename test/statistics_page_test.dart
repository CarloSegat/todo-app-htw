import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/statistics_page.dart';
import 'package:todo/todo.dart';
import 'package:todo/todos_scope.dart';

void main() {
  Widget harness(List<Todo> todos) {
    return TodosScope(
      initialTodos: todos,
      child: const MaterialApp(home: StatisticsPage()),
    );
  }

  testWidgets('empty list → Total: 0, Completed: 0%', (tester) async {
    await tester.pumpWidget(harness(const []));

    expect(find.text('Total: 0'), findsOneWidget);
    expect(find.text('Completed: 0%'), findsOneWidget);
  });

  testWidgets('4 todos, 1 done → Completed: 25%', (tester) async {
    await tester.pumpWidget(
      harness([
        Todo('a', done: true),
        Todo('b'),
        Todo('c'),
        Todo('d'),
      ]),
    );

    expect(find.text('Total: 4'), findsOneWidget);
    expect(find.text('Completed: 25%'), findsOneWidget);
  });
}
