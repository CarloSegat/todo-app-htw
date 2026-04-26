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
}
