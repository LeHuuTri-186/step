import 'dart:convert';
import 'package:collection/collection.dart' show IterableExtension;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:step/core/utils/datetime_util.dart';
import '../../domain/entities/todo.dart';
import '../../domain/repositories/todo_repository.dart';
import '../models/todo_model.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';

class TodoRepositoryImpl implements TodoRepository {
  final SharedPreferences sharedPreferences;

  TodoRepositoryImpl(this.sharedPreferences);

  @override
  Future<List<TodoModel>> getTodos() async {
    final data = sharedPreferences.getStringList('todos') ?? [];
    return mapToTodoList(data);
  }

  List<TodoModel> mapToTodoList(List<String> data) =>
      data.map((item) => TodoModel.fromJson(jsonDecode(item))).toList();

  @override
  Future<void> addTodo(Todo todo) async {
    final todos = await getTodos();
    todos.add(TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dueDay: todo.dueDay,
      deadline: todo.deadline,
      isDone: todo.isDone,
    ));

    await sharedPreferences.setStringList(
      'todos',
      todos.map((t) => jsonEncode(TodoModel.fromJson(t.toJson()))).toList(),
    );
  }

  @override
  Future<void> deleteTodo(String id) async {
    final todos = await getTodos();

    todos.removeWhere((todo) => todo.id == id);

    await _saveToSharedPreference(todos);
  }

  @override
  Future<void> toggleTodoCompletion(String id) async {
    final todos = await getTodos();
    final index = todos.indexWhere((todo) => todo.id == id);

    if (index != -1) {
      final toggledTodo = TodoModel(
        id: todos[index].id,
        title: todos[index].title,
        description: todos[index].description,
        isDone: !todos[index].isDone,
        dueDay: todos[index].dueDay,
        deadline: todos[index].deadline,
      );

      todos[index] = toggledTodo;

      await _saveToSharedPreference(todos);
    }
  }

  Future<void> _saveToSharedPreference(List<TodoModel> todos) async {
    await sharedPreferences.setStringList(
      'todos',
      todos.map((t) => jsonEncode(t.toJson())).toList(),
    );
  }

  @override
  Future<Todo?> getTodo(String id) async {
    final data = sharedPreferences.getStringList('todos') ?? [];

    return mapToTodoList(data).firstWhereOrNull((todo) => todo.id == id);
  }

  @override
  Future<List<Todo>> getTodoByDate(DateTime date) async {
    final todos = await getTodos();

    return todos
        .where((todo) => DateTimeUtil.isSameDay(todo.dueDay, date))
        .toList();
  }

  @override
  Future<List<Todo>> getUpcomingTodo() async {
    final todos = await getTodos();

    return todos
        .where((todo) => DateTimeUtil.isDayBefore(DateTime.now(), todo.dueDay))
        .toList();
  }

  @override
  Future<List<Todo>> findTodoByTitle(
      {required String title, double threshold = 70.0}) async {
    final todos = await getTodos();
    return todos.where((todo) {
      final similarity = ratio(title, todo.title);
      return similarity >= threshold;
    }).toList();
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    final todos = await getTodos();

    todos.removeWhere((td) => td.id == todo.id);

    todos.add(TodoModel(
      id: todo.id,
      title: todo.title,
      description: todo.description,
      dueDay: todo.dueDay,
      deadline: todo.deadline,
      isDone: todo.isDone,
    ));

    _saveToSharedPreference(todos);
  }

  @override
  Future<List<Todo>> getOverdueTodo() async {
    final todos = await getTodos();

    return todos.where((todo) {
      bool isDue = DateTimeUtil.isDayBefore(todo.dueDay, DateTime.now());

      if (todo.deadline != null) {
        isDue = todo.deadline!.isBefore(DateTime.now());
      }

      return isDue;
    }).toList();
  }
}
