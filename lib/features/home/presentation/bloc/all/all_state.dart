import '../../../domain/entities/todo.dart';

abstract class AllState {}

class AllLoading extends AllState {}

class AllLoaded extends AllState {
  final List<Todo> allTodos;
  final List<Todo> upcomingTodos;
  final List<Todo> todayTodos;

  AllLoaded({required this.allTodos, required this.upcomingTodos, required this.todayTodos});
}

class NoTodoFound extends AllState {}

class AllError extends AllState {}
