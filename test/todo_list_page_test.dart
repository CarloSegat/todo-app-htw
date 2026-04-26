import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/statistics_page.dart';
import 'package:todo/todo.dart';
import 'package:todo/todo_list_page.dart';
import 'package:todo/todos_scope.dart';

void main() {
  Widget harness({List<Todo> todos = const []}) {
    return TodosScope(
      initialTodos: todos,
      child: const MaterialApp(home: TodoListPage()),
    );
  }

  testWidgets('empty list renders no CheckboxListTile', (tester) async {
    await tester.pumpWidget(harness());

    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('renders one tile per todo with title text', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b'), Todo('c')]),
    );

    expect(find.byType(CheckboxListTile), findsNWidgets(3));
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
    expect(find.byType(CheckboxListTile), findsOneWidget);
  });

  testWidgets('empty text + tap Add --> no tile added', (tester) async {
    await tester.pumpWidget(harness());

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsNothing);
    expect(find.byType(CheckboxListTile), findsNothing);
  });

  testWidgets('tap checkbox --> that todo flips to done', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b'), Todo('c')]),
    );

    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump();

    final tile = tester.widget<CheckboxListTile>(
      find.byType(CheckboxListTile).at(1),
    );
    expect(tile.value, true);
  });

  testWidgets('swipe --> tile is removed', (tester) async {
    await tester.pumpWidget(
      harness(todos: [Todo('a'), Todo('b')]),
    );

    await tester.drag(find.text('b'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(find.text('b'), findsNothing);
    expect(find.byType(CheckboxListTile), findsOneWidget);
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
