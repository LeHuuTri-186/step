import 'package:step/core/usecases/usecase.dart';

import '../../repositories/todo_repository.dart';

class ToggleTodoCompletion implements UseCase<void, String> {
  final TodoRepository repository;

  ToggleTodoCompletion({required this.repository});

  @override
  Future<void> call(String id) {
    return repository.toggleTodoCompletion(id);
  }
}