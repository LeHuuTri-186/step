import '../../../../../core/usecases/usecase.dart';
import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class GetUpcomingTodo implements NoParamsUseCase<List<Todo>> {
  final TodoRepository repository;

  GetUpcomingTodo(this.repository);

  @override
  Future<List<Todo>> call() {
    return repository.getUpcomingTodo();
  }
}