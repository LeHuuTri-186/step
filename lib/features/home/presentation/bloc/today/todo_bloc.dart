import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/features/home/domain/usecases/crud_usecases.dart';

import '../../../domain/entities/todo.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final CrudUseCases crudUseCases;
  Timer? _midnightTimer;

  TodoBloc({required this.crudUseCases}) : super(TodayLoading()) {
    _setMidnightTimer();
    on<LoadTodayTodo>((event, emit) async {
      try {
        final List<Todo> todoList = await crudUseCases.readUseCases.getTodoByDay.call(DateTime.now());

        if (todoList.isEmpty) {
          emit(NoTodoToday());
          return;
        }

        emit(TodayLoaded(todoList: todoList));
      } catch (e) {
        emit(TodayError());

        debugPrint(e.toString());
      }
    });

    on<AddTodoEvent>((event, emit) async {
      await crudUseCases.createUseCases.addTodo.call(event.newTodo);
      add(LoadTodayTodo());
    });

    on<RemoveTodoEvent>((event, emit) async {
      try {
        await crudUseCases.deleteUseCases.removeTodo.call(event.removedTodo);
        add(LoadTodayTodo());
      } catch (e) {
        emit(TodayError());
      }
    });

    on<ToggleTodoCompletion>((event, emit) async {
      await crudUseCases.updateUseCases.toggleTodoCompletion.call(event.id);
      add(LoadTodayTodo());

      await Future.delayed(const Duration(seconds: 3));

      Todo? todo = await crudUseCases.readUseCases.getTodo(event.id);

      if (todo!.isDone) {
        await crudUseCases.deleteUseCases.removeTodo.call(todo);
      }

      add(LoadTodayTodo());
    });

    on<DateChanged>((event, emit) async {
      add(LoadTodayTodo());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await crudUseCases.updateUseCases.updateTodo(event.todo);

      add(LoadTodayTodo());
    });
  }

  void _setMidnightTimer() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _setMidnightTimer();
      add(DateChanged(DateTime.now()));
      // Trigger date change at midnight
    });
  }

  @override
  Future<void> close() {
    _midnightTimer?.cancel();
    return super.close();
  }
}
