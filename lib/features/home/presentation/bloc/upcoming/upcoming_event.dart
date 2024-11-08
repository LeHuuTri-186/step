import '../../../domain/entities/todo.dart';

abstract class UpcomingEvent {}

class LoadUpcomingTodo extends UpcomingEvent {}

class DateChanged extends UpcomingEvent {
  DateChanged();
}

class RemoveTodoEvent extends UpcomingEvent {
  final Todo removedTodo;

  RemoveTodoEvent({required this.removedTodo});
}

class AddTodoEvent extends UpcomingEvent {
  final Todo newTodo;

  AddTodoEvent({required this.newTodo});
}

class ToggleTodoCompletion extends UpcomingEvent {
  final String id;

  ToggleTodoCompletion(this.id);
}

class UpdateTodoEvent extends UpcomingEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}

