import 'package:flutter/cupertino.dart';
import 'package:step/core/usecases/usecase.dart';
import 'package:step/core/utils/notification_helper.dart';

import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class UpdateTodo implements UseCase<void, Todo> {
  final TodoRepository repository;

  UpdateTodo({required this.repository});

  @override
  Future<void> call(Todo todo) {
    try {
      if (todo.notificationId != null) {
        NotificationHelper.cancelNotification(todo.notificationId!);
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      todo.notificationId = null;
    }

    if (todo.deadline != null) {
      todo.notificationId = NotificationHelper.generateNotificationId();

      NotificationHelper.scheduleNotification(todo: todo);
    }

    return repository.updateTodo(todo);
  }
}
