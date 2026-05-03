import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'statistics_page.dart';
import 'task_detail_page.dart';
import 'todo_list_page.dart';
import 'todos_scope.dart';

final _routerConfig = GoRouter(
  redirect: (_, state) {
    final uri = state.uri;
    if (uri.host == 'task' && uri.pathSegments.isNotEmpty) {
      // removing the scheme from the link
      return '/task/${uri.pathSegments.first}';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      builder: (_, _) => const TodoListPage(),
      routes: [
        GoRoute(
          path: 'stats',
          builder: (_, _) => const StatisticsPage(),
        ),
        GoRoute(
          path: 'task/:id',
          builder: (_, state) =>
              TaskDetailPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
);

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return TodosScope(
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: _routerConfig,
      ),
    );
  }
}

void main() => runApp(const TodoApp());
