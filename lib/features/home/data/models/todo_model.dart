import '../../domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required String super.id,
    required super.title,
    super.description,
    DateTime? dueDay,
    super.deadline,
    super.isDone,
    super.notificationId,
  }) : super(
    creationTime: dueDay ?? DateTime.now(),
  );

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? "",
      dueDay: DateTime.parse(json['dueDay']),
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null,
      isDone: json['isDone'] ?? false,
      notificationId: json['notificationId']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDay': dueDay.toIso8601String(),
      'deadline': deadline?.toIso8601String(),
      'isDone': isDone,
      'notificationId': notificationId,
    };
  }
}
