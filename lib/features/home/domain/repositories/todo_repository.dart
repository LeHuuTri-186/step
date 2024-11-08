import 'package:step/features/home/domain/entities/todo.dart';

abstract class TodoRepository {
  Future<List<Todo>> getTodos();
  Future<void> addTodo(Todo todo);
  Future<void> deleteTodo(String id);
  Future<void> toggleTodoCompletion(String id);
  Future<Todo?> getTodo(String id);
  Future<List<Todo>> getTodoByDate(DateTime date);
  Future<List<Todo>> getUpcomingTodo();
  Future<List<Todo>> findTodoByTitle({required String title, double threshold});
  Future<void> updateTodo(Todo todo);
}