import 'dart:convert';
import 'package:http/http.dart' as http;
import 'todo.dart';

const _baseUrl = 'http://10.0.2.2:8000'; // emulator's alias for localhost

class ApiClient {
  static Future<List<Todo>> fetchAll() async {
    final response = await http.get(Uri.parse('$_baseUrl/todos'));

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch todos: ${response.statusCode}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map(_parseTodo).toList();
  }

  static Future<Todo> create(Todo todo) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/todos'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': todo.id,
        'title': todo.title,
        'description': todo.description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create todo: ${response.statusCode}');
    }

    return _parseTodo(jsonDecode(response.body));
  }

  static Future<Todo> update(
    String id, {
    String? title,
    String? description,
    bool? done,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (description != null) body['description'] = description;
    if (done != null) body['done'] = done;

    final response = await http.put(
      Uri.parse('$_baseUrl/todos/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo: ${response.statusCode}');
    }

    return _parseTodo(jsonDecode(response.body));
  }

  static Future<void> delete(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/todos/$id'));

    if (response.statusCode != 204) {
      throw Exception('Failed to delete todo: ${response.statusCode}');
    }
  }

  // unused for now...
  static Future<Todo?> getById(String id) async {
    final response = await http.get(Uri.parse('$_baseUrl/todos/$id'));

    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw Exception('Failed to fetch todo: ${response.statusCode}');
    }

    return _parseTodo(jsonDecode(response.body));
  }

  static Todo _parseTodo(dynamic json) => Todo(
        json['title'],
        id: json['id'],
        description: json['description'],
        done: json['done'],
        createdAt: DateTime.parse(json['createdAt']),
      );
}
