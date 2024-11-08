import '../../../domain/entities/todo.dart';

abstract class SearchState {}

class Searching extends SearchState {}

class Searched extends SearchState {
  final List<Todo> todoList;

  Searched({required this.todoList});
}

class NoTodoFound extends SearchState {}

class SearchError extends SearchState {}
