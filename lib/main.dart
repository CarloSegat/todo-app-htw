import 'dart:async';

import 'package:app_links/app_links.dart';
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

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final _appLinks = AppLinks();

  // just holds the "subscription" object to the appLinks "bridge"
  StreamSubscription<Uri>? _sub;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  Future<void> _initDeepLinks() async {
    // deeplinks have the so called "cold start problem"
    // app already running when deeplink pressed --> all good / "warm" start
    // app NOT already running (i.e. app is launched by the OS after deeplink pressed) --> cold start

    // if it's cols start the stream will not fire the event
    final initial = await _appLinks.getInitialLink();
    if (initial != null) _handleDeeplink(initial);

    // everytime the native part of our app recives a link from the OS, please call `_handle`
    _sub = _appLinks.uriLinkStream.listen(_handleDeeplink);
  }

  void _handleDeeplink(Uri uri) {
    if (uri.scheme != 'todoapp') return;
    if (uri.host == 'task' && uri.pathSegments.isNotEmpty) {
      _routerConfig.go('/task/${uri.pathSegments.first}');
    }
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

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
