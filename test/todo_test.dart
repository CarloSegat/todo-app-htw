import 'package:flutter_test/flutter_test.dart';
import 'package:todo/todo.dart';

void main() {
  group('Todo.toggle', () {
    test('flips done, keeps title', () {
      final t = Todo('buy milk');
      final toggled = t.toggle();

      expect(toggled.title, 'buy milk');
      expect(toggled.done, true);
    });

    test('double toggle returns to original state', () {
      final t = Todo('buy milk');
      final twice = t.toggle().toggle();

      expect(twice.title, 'buy milk');
      expect(twice.done, false);
    });
  });

  group('Todo.id', () {
    test('two todos have distinct auto-generated ids', () {
      final a = Todo('a');
      final b = Todo('b');

      expect(a.id, isNotEmpty);
      expect(b.id, isNotEmpty);
      expect(a.id, isNot(b.id));
    });

    test('copyWith preserves id', () {
      final a = Todo('a');
      final updated = a.copyWith(title: 'b', done: true);

      expect(updated.id, a.id);
    });

    test('toggle preserves id', () {
      final a = Todo('a');
      expect(a.toggle().id, a.id);
    });
  });
}
