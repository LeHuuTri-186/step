import 'package:step/core/usecases/usecase.dart';

import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class GetTodos implements NoParamsUseCase<List<Todo>> {
  final TodoRepository repository;

  GetTodos(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getTodos();
  }
}