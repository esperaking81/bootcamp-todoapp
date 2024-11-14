import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../pages/todo_list.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => _TodoAppState();
}

class _TodoAppState extends State<TodoApp> {
  final List<Todo> todos = [];

  void addTodo(Todo todo) {
    todos.add(todo);
    setState(() {});
  }

  void markTodoAsCompleted(String id, bool isAlreadyCompleted) {
    for (final todo in todos) {
      if (todo.id == id) {
        todo.isCompleted = !isAlreadyCompleted;
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: false,
        primaryColor: Colors.blue,
        brightness: Brightness.dark,
        fontFamily: 'Raleway',
      ),
      home: TodoList(
        todos: todos,
        addTodo: addTodo,
        markTodoAsCompleted: markTodoAsCompleted,
      ),
    );
  }
}
