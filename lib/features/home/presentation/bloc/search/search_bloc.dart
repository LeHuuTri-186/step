import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/core/usecases/param/search_params.dart';
import 'package:step/features/home/domain/usecases/crud_usecases.dart';

import '../../../domain/entities/todo.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final CrudUseCases crudUseCases;
  String _previousTitle = '';

  SearchBloc({required this.crudUseCases}) : super(Searching()) {
    on<RefreshSearch>((event, emit) async {
      try {
        SearchParams searchParams = SearchParams(title: _previousTitle);
        final List<Todo> todoList = await crudUseCases.readUseCases.findTodoByTitle.call(searchParams);

        if (todoList.isEmpty) {
          emit(NoTodoFound());
          return;
        }

        emit(Searched(todoList: todoList));
      } catch (e) {
        emit(SearchError());

        debugPrint(e.toString());
      }
    });

    on<SearchTodos>((event, emit) async {
      _previousTitle = event.title;
      try {
        SearchParams searchParams = SearchParams(title: event.title);
        final List<Todo> todoList = await crudUseCases.readUseCases.findTodoByTitle.call(searchParams);

        if (todoList.isEmpty) {
          emit(NoTodoFound());
          return;
        }

        emit(Searched(todoList: todoList));
      } catch (e) {
        emit(SearchError());

        debugPrint(e.toString());
      }
    });

    on<AddTodoEvent>((event, emit) async {
      await crudUseCases.createUseCases.addTodo.call(event.newTodo);
      add(SearchTodos());
    });

    on<RemoveTodoEvent>((event, emit) async {
      try {
        await crudUseCases.deleteUseCases.removeTodo.call(event.removedTodo);
        add(RefreshSearch());
      } catch (e) {
        emit(SearchError());
      }
    });

    on<ToggleTodoCompletion>((event, emit) async {
      await crudUseCases.updateUseCases.toggleTodoCompletion.call(event.id);
      add(RefreshSearch());

      await Future.delayed(const Duration(seconds: 3));

      Todo? todo = await crudUseCases.readUseCases.getTodo(event.id);

      if (todo != null && todo.isDone) {
        await crudUseCases.deleteUseCases.removeTodo.call(todo);
      }

      add(RefreshSearch());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await crudUseCases.updateUseCases.updateTodo(event.todo);

      add(RefreshSearch());
    });
  }
}
