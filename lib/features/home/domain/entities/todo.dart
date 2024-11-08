import 'package:uuid/uuid.dart';

class Todo {
  Todo({
    String? id,
    required this.title, this.description = "", this.deadline, this.isDone = false, this.notificationId, DateTime? creationTime})
      : id = id ?? const Uuid().v4(), dueDay = creationTime ?? DateTime.now();

  Todo.copy(Todo original)
      : id = original.id,
        title = original.title,
        description = original.description,
        dueDay = original.dueDay,
        deadline = original.deadline,
        isDone = original.isDone,
        notificationId = original.notificationId;

  final String id;
  String title;
  String description;
  late DateTime dueDay;
  DateTime? deadline;
  late bool isDone;
  int? notificationId;
}