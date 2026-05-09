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
    return data
        .map((json) => Todo(
              json['title'],
              id: json['id'],
              description: json['description'],
              done: json['done'],
              createdAt: DateTime.parse(json['createdAt']),
            ))
        .toList();
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

    final json = jsonDecode(response.body);
    return Todo(
      json['title'],
      id: json['id'],
      description: json['description'],
      done: json['done'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
