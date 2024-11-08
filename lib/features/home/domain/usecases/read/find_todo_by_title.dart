import 'package:step/core/usecases/param/search_params.dart';

import '../../../../../core/usecases/usecase.dart';
import '../../entities/todo.dart';
import '../../repositories/todo_repository.dart';

class FindTodoByTitle implements UseCase<List<Todo>, SearchParams> {
  final TodoRepository repository;

  FindTodoByTitle(this.repository);

  @override
  Future<List<Todo>> call(SearchParams searchParams) {
    return repository.findTodoByTitle(title: searchParams.title, threshold: searchParams.threshold);
  }
}