import 'package:step/features/home/domain/usecases/update/update_todo.dart';

import 'toggle_todo_completion.dart';

class UpdateUseCases {
  final ToggleTodoCompletion toggleTodoCompletion;
  final UpdateTodo updateTodo;

  UpdateUseCases({required this.updateTodo, required this.toggleTodoCompletion});
}