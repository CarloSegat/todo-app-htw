import 'package:flutter/widgets.dart';

import 'api_client.dart';
import 'todo.dart';

class TodosScope extends StatefulWidget {
  const TodosScope({
    super.key,
    required this.child,
    this.initialTodos = const [],
  });

  final Widget child;
  final List<Todo> initialTodos;

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

  @override
  void initState() {
    super.initState();
    _fetchAll();
  }

  Future<void> _fetchAll() async {
    try {
      final todos = await ApiClient.fetchAll();
      if (mounted) {
        setState(() => _todos = todos);
      }
    } catch (e) {
      print('Error fetching todos: $e');
    }
  }

  Future<void> _add(String title) async {
    try {
      final todo = Todo(title);
      final created = await ApiClient.create(todo);
      if (mounted) {
        setState(() => _todos = [..._todos, created]);
      }
    } catch (e) {
      print('Error creating todo: $e');
    }
  }

  void _toggle(String id) => setState(() {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _todos = [
      ..._todos.sublist(0, i),
      _todos[i].toggle(),
      ..._todos.sublist(i + 1),
    ];
  });

  void _delete(String id) => setState(() {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _todos = [..._todos.sublist(0, i), ..._todos.sublist(i + 1)];
  });

  void _update(String id, Todo updated) => setState(() {
    final i = _todos.indexWhere((t) => t.id == id);
    if (i == -1) return;
    _todos = [
      ..._todos.sublist(0, i),
      updated,
      ..._todos.sublist(i + 1),
    ];
  });

  @override
  Widget build(BuildContext context) {
    return TodosInherited._(
      todos: _todos,
      add: _add,
      toggle: _toggle,
      delete: _delete,
      update: _update,
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
    required this.update,
    required super.child, // InheritedWidget must have a child (to continue the tree)
  });

  final List<Todo> todos;
  final Future<void> Function(String title) add;
  final void Function(String id) toggle;
  final void Function(String id) delete;
  final void Function(String id, Todo updated) update;

  Todo? findById(String id) {
    for (final t in todos) {
      if (t.id == id) return t;
    }
    return null;
  }

  // when this widget is rebuilt, rebuild its descendants ONLY IF the todos changed
  @override
  bool updateShouldNotify(TodosInherited old) => old.todos != todos;
}
