import '../../../domain/entities/todo.dart';

abstract class AllEvent {}

class RefreshAll extends AllEvent {}

class RemoveTodoEvent extends AllEvent {
  final Todo removedTodo;

  RemoveTodoEvent({required this.removedTodo});
}

class AddTodoEvent extends AllEvent {
  final Todo newTodo;

  AddTodoEvent({required this.newTodo});
}

class ToggleTodoCompletion extends AllEvent {
  final String id;

  ToggleTodoCompletion(this.id);
}

class UpdateTodoEvent extends AllEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}

