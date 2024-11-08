import 'package:step/core/utils/notification_helper.dart';
import 'package:step/features/home/domain/entities/todo.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../repositories/todo_repository.dart';

class AddTodo implements UseCase<void, Todo> {
  final TodoRepository repository;

  AddTodo(this.repository);

  @override
  Future<void> call(Todo todo) {

    if (todo.deadline != null) {
      todo.notificationId = NotificationHelper.generateNotificationId();
      NotificationHelper.scheduleNotification(todo: todo);
    }

    return repository.addTodo(todo);
  }
}