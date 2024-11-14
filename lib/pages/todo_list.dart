import 'package:flutter/material.dart';
import 'package:todoapp/models/todo.dart';
import 'package:todoapp/pages/edit_todo.dart';

import '../design/colors.dart';

class TodoList extends StatelessWidget {
  const TodoList({
    super.key,
    required this.todos,
    required this.addTodo,
    required this.markTodoAsCompleted,
  });

  final List<Todo> todos;
  final void Function(Todo) addTodo;
  final void Function(String id, bool isAlreadyCompleted) markTodoAsCompleted;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData mq = MediaQuery.of(context);
    final Size size = mq.size;
    final double screenHeight = size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(screenHeight * .1),
        child: AppBar(
          title: const Text(
            'Todo List',
            style:  TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: AppColors.primary,
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: screenHeight * .05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Header(),
            const SizedBox(height: 24),
            Expanded(
              child: _TodoList(
                todos: todos,
                markTodoAsCompleted: markTodoAsCompleted,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Todo? todo = await showModalBottomSheet(
            context: context,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            builder: (_) => const EditTodo(),
          );

          if (todo != null) {
            addTodo(todo);
          }
        },
        backgroundColor: AppColors.primaryDark,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _TodoList extends StatelessWidget {
  const _TodoList({
    required this.todos,
    required this.markTodoAsCompleted,
  });

  final List<Todo> todos;
  final void Function(String id, bool isAlreadyCompleted) markTodoAsCompleted;

  @override
  Widget build(BuildContext context) {
    if (todos.isEmpty) {
      return const Text('No tasks found.');
    }

    return ListView.separated(
      itemCount: todos.length,
      itemBuilder: (_, int index) {
        return _TodoItem(
          todo: todos[index],
          markTodoAsCompleted: markTodoAsCompleted,
        );
      },
      separatorBuilder: (_, __) => const SizedBox(height: 8),
    );
  }
}

class _TodoItem extends StatelessWidget {
  const _TodoItem({
    required this.todo,
    required this.markTodoAsCompleted,
  });

  final Todo todo;
  final void Function(String id, bool isAlreadyCompleted) markTodoAsCompleted;

  @override
  Widget build(BuildContext context) {
    final dynamicTextStyle = TextStyle(
      color: todo.isCompleted ? Colors.grey : Colors.white,
    );

    return Container(
      decoration: todoItemBoxDecoration,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CustomCheckbox(
            isChecked: todo.isCompleted,
            onCheckedChanged: () {
              markTodoAsCompleted(todo.id, todo.isCompleted);
            },
          ),
          Expanded(
            child: Text(
              todo.task,
              style: dynamicTextStyle.copyWith(
                decoration: todo.isCompleted
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
          ),
          Text(todo.time, style: dynamicTextStyle),
        ],
      ),
    );
  }
}

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.isChecked,
    required this.onCheckedChanged,
  });

  final bool isChecked;
  final VoidCallback onCheckedChanged;
  @override
  Widget build(BuildContext context) {
    final foregroundColor = computeForegroundColor(isChecked);

    return GestureDetector(
      onTap: onCheckedChanged,
      child: Container(
        width: 16,
        height: 16,
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: foregroundColor,
            width: isChecked ? 1 : 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 12,
            color: isChecked ? Colors.grey : Colors.transparent,
          ),
        ),
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Today',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'March 4, 2010',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}

// static variables
final todoItemBoxDecoration = BoxDecoration(
  borderRadius: BorderRadius.circular(8),
  color: Colors.white10,
);

// methods
Color computeForegroundColor(bool isChecked) {
  return isChecked ? Colors.grey : Colors.white;
}
