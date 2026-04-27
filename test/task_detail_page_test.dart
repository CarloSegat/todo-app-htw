import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/task_detail_page.dart';
import 'package:todo/todo.dart';
import 'package:todo/todo_list_page.dart';
import 'package:todo/todos_scope.dart';

void main() {
  Widget harness(List<Todo> todos) {
    return TodosScope(
      initialTodos: todos,
      child: const MaterialApp(home: TodoListPage()),
    );
  }

  testWidgets('renders title, createdAt and description', (tester) async {
    final created = DateTime(2026, 1, 15, 9, 30);
    await tester.pumpWidget(
      harness([
        Todo('buy milk', createdAt: created, description: '2 liters'),
      ]),
    );

    await tester.tap(find.text('buy milk'));
    await tester.pumpAndSettle();

    expect(find.byType(TaskDetailPage), findsOneWidget);
    expect(find.text('buy milk'), findsOneWidget);
    expect(find.textContaining('2026-01-15'), findsOneWidget);
    expect(find.text('2 liters'), findsOneWidget);
  });
}
