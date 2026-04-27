class Todo {
  Todo(
    this.title, {
    this.done = false,
    DateTime? createdAt,
    this.description = '',
  }) : createdAt = createdAt ?? DateTime.now();

  final String title;
  final bool done;
  final DateTime createdAt;
  final String description;

  Todo copyWith({String? title, bool? done, String? description}) => Todo(
    title ?? this.title,
    done: done ?? this.done,
    createdAt: createdAt,
    description: description ?? this.description,
  );

  Todo toggle() => copyWith(done: !done);
}
