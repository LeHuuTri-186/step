import 'package:step/features/home/domain/usecases/read/find_todo_by_title.dart';
import 'package:step/features/home/domain/usecases/read/get_overdue_todo.dart';
import 'package:step/features/home/domain/usecases/read/get_upcoming_todo.dart';

import 'get_todo.dart';
import 'get_todo_by_day.dart';
import 'get_todos.dart';

class ReadUseCases {
  final GetTodo getTodo;
  final GetTodos getAll;
  final GetTodoByDay getTodoByDay;
  final GetUpcomingTodo getUpcomingTodo;
  final FindTodoByTitle findTodoByTitle;
  final GetOverTodo getOverTodo;

  ReadUseCases({required this.getOverTodo, required this.getUpcomingTodo,required this.getTodoByDay, required this.getTodo, required this.getAll, required this.findTodoByTitle, });
}