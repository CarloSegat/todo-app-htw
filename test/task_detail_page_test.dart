import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:todo/statistics_page.dart';
import 'package:todo/task_detail_page.dart';
import 'package:todo/todo.dart';
import 'package:todo/todo_list_page.dart';
import 'package:todo/todos_scope.dart';

GoRouter _router() => GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const TodoListPage(),
      routes: [
        GoRoute(path: 'stats', builder: (_, _) => const StatisticsPage()),
        GoRoute(
          path: 'task/:id',
          builder: (_, s) => TaskDetailPage(id: s.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

void main() {
  Widget harness(List<Todo> todos) {
    return TodosScope(
      initialTodos: todos,
      child: MaterialApp.router(routerConfig: _router()),
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
