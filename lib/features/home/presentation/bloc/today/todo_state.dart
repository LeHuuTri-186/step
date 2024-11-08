import '../../../domain/entities/todo.dart';

abstract class TodoState {}

class TodayLoading extends TodoState {}

class TodayLoaded extends TodoState {
  final List<Todo> todoList;

  TodayLoaded({required this.todoList});
}

class NoTodoToday extends TodoState {}

class TodayError extends TodoState {}