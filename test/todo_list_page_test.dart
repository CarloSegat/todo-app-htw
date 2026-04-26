import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:todo/statistics_page.dart';
import 'package:todo/todo.dart';
import 'package:todo/todo_list_page.dart';

void main() {
  Widget harness({
    required List<Todo> todos,
    void Function(String)? onAdd,
    void Function(int)? onToggle,
    void Function(int)? onDelete,
  }) {
    return MaterialApp(
      home: TodoListPage(
        todos: todos,
        onAdd: onAdd ?? (_) {},
        onToggle: onToggle ?? (_) {},
        onDelete: onDelete ?? (_) {},
      ),
    );
  }

  testWidgets('empty list renders no CheckboxListTile', (tester) async {
    await tester.pumpWidget(harness(todos: const []));

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

  testWidgets('type text + tap Add --> onAdd called; dialog closes', (
    tester,
  ) async {
    final addCalls = <String>[];
    await tester.pumpWidget(harness(todos: const [], onAdd: addCalls.add));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'eggs');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(addCalls, ['eggs']);
    expect(find.byType(AlertDialog), findsNothing);
  });

  testWidgets('empty text + tap Add --> onAdd NOT called', (tester) async {
    final addCalls = <String>[];
    await tester.pumpWidget(harness(todos: const [], onAdd: addCalls.add));

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    expect(addCalls, isEmpty);
    expect(find.byType(AlertDialog), findsNothing);
  });

  
  testWidgets('tap checkbox --> onToggle called with correct index', (
    tester,
  ) async {
    final toggleCalls = <int>[];
    await tester.pumpWidget(
      harness(
        todos: [Todo('a'), Todo('b'), Todo('c')],
        onToggle: toggleCalls.add,
      ),
    );

    await tester.tap(find.byType(CheckboxListTile).at(1));
    await tester.pump();

    // in the todo list page we wrote `onChanged: (_) => onToggle(i)`

    expect(toggleCalls, [1]);
  });

  testWidgets('swipe --> onDelete called', (
    tester,
  ) async {
    final deleteCalls = <int>[];
    await tester.pumpWidget(
      harness(
        todos: [Todo('a'), Todo('b')],
        onDelete: deleteCalls.add,
      ),
    );

    // in the todo list we wrote: `onDismissed: (_) => onDelete(i)`

    await tester.drag(find.text('b'), const Offset(-500, 0));
    await tester.pumpAndSettle();

    expect(deleteCalls, [1]);
  });

  testWidgets('tap bar_chart icon --> navigates to StatisticsPage', (
    tester,
  ) async {
    await tester.pumpWidget(harness(todos: const []));

    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();

    expect(find.byType(StatisticsPage), findsOneWidget);
  });
}
