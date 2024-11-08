import '../../../domain/entities/todo.dart';

abstract class UpcomingState {}

class UpcomingLoading extends UpcomingState {}

class UpcomingLoaded extends UpcomingState {
  final List<Todo> todoList;

  UpcomingLoaded({required this.todoList});
}

class NoUpcomingTodo extends UpcomingState {}

class UpcomingError extends UpcomingState {}
