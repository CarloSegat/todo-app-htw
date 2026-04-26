import 'package:flutter/widgets.dart';

import 'todo.dart';

class TodosScope extends StatefulWidget {
  const TodosScope({
    super.key,
    required this.child,
    this.initialTodos = const [],
  });

  final Widget child;
  final List<Todo> initialTodos;

  // "of" is a naming convention in Flutter
  static TodosInherited of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<TodosInherited>();
    assert(scope != null, 'No TodosScope found in context');
    return scope!;
  }

  @override
  State<TodosScope> createState() => _TodosScopeState();
}

class _TodosScopeState extends State<TodosScope> {
  late List<Todo> _todos = List.of(widget.initialTodos);

  void _add(String title) =>
      setState(() => _todos = [..._todos, Todo(title)]);

  void _toggle(int i) => setState(() {
    _todos = [
      ..._todos.sublist(0, i),
      _todos[i].toggle(),
      ..._todos.sublist(i + 1),
    ];
  });

  void _delete(int i) => setState(() {
    _todos = [..._todos.sublist(0, i), ..._todos.sublist(i + 1)];
  });

  @override
  Widget build(BuildContext context) {
    return TodosInherited._(
      todos: _todos,
      add: _add,
      toggle: _toggle,
      delete: _delete,
      child: widget.child,
    );
  }
}


// InheritedWidget saves you from the hell of porps drilling
// if a widget is an inherited widget then its fields are accessible from descendant widgets
class TodosInherited extends InheritedWidget {

  // private constructor
  const TodosInherited._({
    required this.todos,
    required this.add,
    required this.toggle,
    required this.delete,
    required super.child, // InheritedWidget must have a child (to continue the tree)
  });

  final List<Todo> todos;
  final void Function(String title) add;
  final void Function(int index) toggle;
  final void Function(int index) delete;

  // when this widget is rebuilt, rebuild its descendants ONLY IF the todos changed
  @override
  bool updateShouldNotify(TodosInherited old) => old.todos != todos;
}
