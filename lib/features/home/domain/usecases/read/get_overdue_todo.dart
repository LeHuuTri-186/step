import 'package:step/core/usecases/param/search_params.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class GetOverTodo implements NoParamsUseCase<List<Todo>> {
  final TodoRepository repository;

  GetOverTodo(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getOverdueTodo();
  }
}