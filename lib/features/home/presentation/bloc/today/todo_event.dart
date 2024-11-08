import '../../../domain/entities/todo.dart';

abstract class TodoEvent {}

class LoadTodayTodo extends TodoEvent {}

class DateChanged extends TodoEvent {
  final DateTime newDate;

  DateChanged(this.newDate);
}

class RemoveTodoEvent extends TodoEvent {
  final Todo removedTodo;

  RemoveTodoEvent({required this.removedTodo});
}

class AddTodoEvent extends TodoEvent {
  final Todo newTodo;

  AddTodoEvent({required this.newTodo});
}

class ToggleTodoCompletion extends TodoEvent {
  final String id;

  ToggleTodoCompletion(this.id);
}

class UpdateTodoEvent extends TodoEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}
