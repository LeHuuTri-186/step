import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step/features/home/domain/usecases/create/create_usecases.dart';
import 'package:step/features/home/domain/usecases/crud_usecases.dart';
import 'package:step/features/home/domain/usecases/read/find_todo_by_title.dart';
import 'package:step/features/home/domain/usecases/read/get_overdue_todo.dart';
import 'package:step/features/home/domain/usecases/read/get_todo_by_day.dart';
import 'package:step/features/home/domain/usecases/read/get_upcoming_todo.dart';
import 'package:step/features/home/domain/usecases/update/toggle_todo_completion.dart';
import 'package:step/features/home/domain/usecases/update/update_todo.dart';
import '../domain/usecases/create/add_todo.dart';
import '../domain/usecases/delete/delete_usecases.dart';
import '../domain/usecases/delete/remove_todo.dart';

import '../data/repositories/todo_repository_impl.dart';
import '../domain/repositories/todo_repository.dart';
import '../domain/usecases/read/get_todo.dart';
import '../domain/usecases/read/get_todos.dart';
import '../domain/usecases/read/read_usecases.dart';
import '../domain/usecases/update/update_usecases.dart';

final getIt = GetIt.instance;

Future<void> initHome() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  getIt.registerSingleton<TodoRepository>(
      TodoRepositoryImpl(getIt<SharedPreferences>()));

  // Usecases
  getIt.registerSingleton<AddTodo>(AddTodo(getIt<TodoRepository>()));
  getIt.registerSingleton<RemoveTodo>(RemoveTodo(getIt<TodoRepository>()));
  getIt.registerSingleton<GetTodo>(GetTodo(getIt<TodoRepository>()));
  getIt.registerSingleton<GetTodos>(GetTodos(getIt<TodoRepository>()));
  getIt.registerSingleton<GetTodoByDay>(GetTodoByDay(getIt<TodoRepository>()));
  getIt.registerSingleton<GetUpcomingTodo>(GetUpcomingTodo(getIt<TodoRepository>()));
  getIt.registerSingleton<FindTodoByTitle>(FindTodoByTitle(getIt<TodoRepository>()));
  getIt.registerSingleton<UpdateTodo>(UpdateTodo(repository: getIt<TodoRepository>()));
  getIt.registerSingleton<GetOverTodo>(GetOverTodo(getIt<TodoRepository>()));
  getIt.registerSingleton<ToggleTodoCompletion>(
      ToggleTodoCompletion(repository: getIt<TodoRepository>()));

  // CRUID usecases
  getIt.registerSingleton<CreateUseCases>(
      CreateUseCases(addTodo: getIt<AddTodo>()));
  getIt.registerSingleton<DeleteUseCases>(
      DeleteUseCases(removeTodo: getIt<RemoveTodo>()));
  getIt.registerSingleton<UpdateUseCases>(
      UpdateUseCases(toggleTodoCompletion: getIt<ToggleTodoCompletion>(), updateTodo: getIt<UpdateTodo>()));
  getIt.registerSingleton<ReadUseCases>(
      ReadUseCases(getTodo: getIt<GetTodo>(), getAll: getIt<GetTodos>(), getTodoByDay: getIt<GetTodoByDay>(), getUpcomingTodo: getIt<GetUpcomingTodo>(), findTodoByTitle: getIt<FindTodoByTitle>(), getOverTodo: getIt<GetOverTodo>()));

  // CRUID
  getIt.registerSingleton<CrudUseCases>(CrudUseCases(
      createUseCases: getIt<CreateUseCases>(),
      readUseCases: getIt<ReadUseCases>(),
      updateUseCases: getIt<UpdateUseCases>(),
      deleteUseCases: getIt<DeleteUseCases>()));
}
