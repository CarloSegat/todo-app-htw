import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class Todo {
  Todo(
    this.title, {
    this.done = false,
    DateTime? createdAt,
    this.description = '',
    String? id,
  }) : createdAt = createdAt ?? DateTime.now(),
       id = id ?? _uuid.v4();

  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;
  final String description;

  Todo copyWith({String? title, bool? done, String? description}) => Todo(
    title ?? this.title,
    done: done ?? this.done,
    createdAt: createdAt,
    description: description ?? this.description,
    id: id,
  );

  Todo toggle() => copyWith(done: !done);
}
