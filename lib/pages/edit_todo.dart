import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/todo.dart';

class EditTodo extends StatefulWidget {
  const EditTodo({super.key});

  @override
  State<EditTodo> createState() => _EditTodoState();
}

class _EditTodoState extends State<EditTodo> {
  // Create a text controller. Later, use it to retrieve the
  // current value of the TextField.
  TimeOfDay? selectedTime;
  String todo = '';
  final todoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    todoController.addListener(() {
      setState(() {
        todo = todoController.text;
      });
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    todoController.removeListener(() {});
    todoController.dispose();
    super.dispose();
  }

  void _submit() {
    final task = todoController.text;
    final time = formattedTimeOfDay;

    if (task.isEmpty || time == null) {
      return;
    }

    // Save the todo and time to the database
    Navigator.of(context).pop(
      Todo(
        id: const Uuid().v4(),
        task: task,
        time: time,
      ),
    );
  }

  void setTime() async {
    // update timeOfDay
    selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    setState(() {});
  }

  String? get formattedTimeOfDay => selectedTime?.format(context);

  bool get isFormValid => todo.isNotEmpty && formattedTimeOfDay != null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text(
                'Add todo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white10,
                  ),
                  child: const Center(
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Task'),
                    TextField(
                      controller: todoController,
                      decoration: const InputDecoration(
                        hintText: 'To-do',
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Completed by'),
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: formattedTimeOfDay ?? 'Time',
                        suffixIcon: const Icon(Icons.keyboard_arrow_down),
                      ),
                      onTap: () => setTime(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: isFormValid ? _submit : null,
            child: Container(
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: isFormValid ? Colors.white10 : Colors.grey,
              ),
              child: const Center(
                child: Text('Save'),
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
