import '../../../../../core/usecases/usecase.dart';
import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class GetTodoByDay implements UseCase<List<Todo>, DateTime> {
  final TodoRepository repository;

  GetTodoByDay(this.repository);

  @override
  Future<List<Todo>> call(DateTime date) {
    return repository.getTodoByDate(date);
  }
}