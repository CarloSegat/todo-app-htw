class Todo {
  Todo(this.title, {this.done = false});

  final String title;
  final bool done;

  Todo toggle() => Todo(title, done: !done);
}
