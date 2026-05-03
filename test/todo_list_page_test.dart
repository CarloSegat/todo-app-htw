import 'package:flutter/material.dart';
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
  Widget harness({List<Todo> todos = const []}) {
    return TodosScope(
      initialTodos: todos,
      child: MaterialApp.router(routerConfig: _router()),
    );
  }

  testWidgets('empty list renders no ListTile', (tester) async {
    await tester.pumpWidget(harness());

    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('renders one tile per todo with title text', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b'), Todo('c')]),
    );

    expect(find.byType(ListTile), findsNWidgets(3));
    expect(find.text('a'), findsOneWidget);
    expect(find.text('b'), findsOneWidget);
    expect(find.text('c'), findsOneWidget);
  });

  testWidgets('type text + tap Add --> tile appears; dialog closes', (
    tester,
  ) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'eggs');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('eggs'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('empty text + tap Add --> no tile added', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(ListTile), findsNothing);
  });

  testWidgets('tap checkbox --> that todo flips to done', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b'), Todo('c')]),
    );

    await tester.tap(find.byType(Checkbox).at(1));
    await tester.pump();

    final box = tester.widget<Checkbox>(find.byType(Checkbox).at(1));
    expect(box.value, true);
  });

  testWidgets('swipe --> tile is removed', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b')]),
    );

    await tester.drag(find.text('b'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('b'), findsNothing);
    expect(find.byType(ListTile), findsOneWidget);
  });

  testWidgets('tap bar_chart icon --> navigates to StatisticsPage', (
    tester,
  ) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();

    expect(find.byType(StatisticsPage), findsOneWidget);
  });
}
