import '../../../domain/entities/todo.dart';

abstract class SearchEvent {}

class RefreshSearch extends SearchEvent {}

class SearchTodos extends SearchEvent {
  final String title;

  SearchTodos({this.title = ''});
}

class RemoveTodoEvent extends SearchEvent {
  final Todo removedTodo;

  RemoveTodoEvent({required this.removedTodo});
}

class AddTodoEvent extends SearchEvent {
  final Todo newTodo;

  AddTodoEvent({required this.newTodo});
}

class ToggleTodoCompletion extends SearchEvent {
  final String id;

  ToggleTodoCompletion(this.id);
}

class UpdateTodoEvent extends SearchEvent {
  final Todo todo;

  UpdateTodoEvent({required this.todo});
}


