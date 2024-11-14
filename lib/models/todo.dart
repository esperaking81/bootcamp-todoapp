class Todo {
  final String id;
  final String task;
  bool isCompleted;
  final String time;

  Todo({
    required this.id,
    required this.task,
    this.isCompleted = false,
    required this.time,
  });
}
