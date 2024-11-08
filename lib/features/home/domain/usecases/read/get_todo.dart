import '../../../../../core/usecases/usecase.dart';
import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class GetTodo implements UseCase<Todo?, String> {
  final TodoRepository repository;

  GetTodo(this.repository);

  @override
  Future<Todo?> call(String id) {
    return repository.getTodo(id);
  }
}