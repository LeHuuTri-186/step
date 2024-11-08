import 'package:step/core/usecases/usecase.dart';
import 'package:step/core/utils/notification_helper.dart';

import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class RemoveTodo implements UseCase<void, Todo?> {
  final TodoRepository repository;

  RemoveTodo(this.repository);

  @override
  Future<void> call(Todo? todo) async {

    if (todo != null && todo.deadline != null && todo.notificationId != null) {
      NotificationHelper.cancelNotification(todo.notificationId!);
    }

    return repository.deleteTodo(todo!.id);
  }
}