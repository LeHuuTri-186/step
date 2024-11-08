import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/core/usecases/param/search_params.dart';
import 'package:step/features/home/domain/usecases/crud_usecases.dart';

import '../../../domain/entities/todo.dart';
import 'all_event.dart';
import 'all_state.dart';

class AllBloc extends Bloc<AllEvent, AllState> {
  final CrudUseCases crudUseCases;

  AllBloc({required this.crudUseCases}) : super(AllLoading()) {
    on<RefreshAll>((event, emit) async {
      try {
        final List<Todo> allTodos = await crudUseCases.readUseCases.getAll.call();
        final List<Todo> todayTodos = await crudUseCases.readUseCases.getTodoByDay.call(DateTime.now());
        final List<Todo> upcomingTodos = await crudUseCases.readUseCases.getUpcomingTodo.call();

        if (allTodos.isEmpty) {
          emit(NoTodoFound());
          return;
        }

        emit(AllLoaded(allTodos: allTodos, upcomingTodos: upcomingTodos, todayTodos: todayTodos));
      } catch (e) {
        emit(AllError());

        debugPrint(e.toString());
      }
    });

    on<AddTodoEvent>((event, emit) async {
      await crudUseCases.createUseCases.addTodo.call(event.newTodo);

      add(RefreshAll());
    });

    on<RemoveTodoEvent>((event, emit) async {
      try {
        await crudUseCases.deleteUseCases.removeTodo.call(event.removedTodo);
        add(RefreshAll());
      } catch (e) {
        emit(AllError());
      }
    });

    on<ToggleTodoCompletion>((event, emit) async {
      await crudUseCases.updateUseCases.toggleTodoCompletion.call(event.id);
      add(RefreshAll());

      await Future.delayed(const Duration(seconds: 3));

      Todo? todo = await crudUseCases.readUseCases.getTodo(event.id);

      if (todo != null && todo.isDone) {
        await crudUseCases.deleteUseCases.removeTodo.call(todo);
      }

      add(RefreshAll());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await crudUseCases.updateUseCases.updateTodo(event.todo);

      add(RefreshAll());
    });
  }
}
