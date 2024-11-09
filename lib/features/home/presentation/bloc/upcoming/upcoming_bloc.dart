import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/features/home/domain/usecases/crud_usecases.dart';

import '../../../domain/entities/todo.dart';
import 'upcoming_event.dart';
import 'upcoming_state.dart';

class UpcomingBloc extends Bloc<UpcomingEvent, UpcomingState> {
  final CrudUseCases crudUseCases;
  Timer? _midnightTimer;

  UpcomingBloc({required this.crudUseCases}) : super(UpcomingLoading()) {
    _setMidnightTimer();
    on<LoadUpcomingTodo>((event, emit) async {
      try {
        final List<Todo> todoList = await crudUseCases.readUseCases.getUpcomingTodo.call();

        if (todoList.isEmpty) {
          emit(NoUpcomingTodo());
          return;
        }

        emit(UpcomingLoaded(todoList: todoList));
      } catch (e) {
        emit(UpcomingError());

        debugPrint(e.toString());
      }
    });

    on<AddTodoEvent>((event, emit) async {
      await crudUseCases.createUseCases.addTodo.call(event.newTodo);
      add(LoadUpcomingTodo());
    });

    on<RemoveTodoEvent>((event, emit) async {
      try {
        await crudUseCases.deleteUseCases.removeTodo.call(event.removedTodo);
        add(LoadUpcomingTodo());
      } catch (e) {
        emit(UpcomingError());
      }
    });

    on<ToggleTodoCompletion>((event, emit) async {
      await crudUseCases.updateUseCases.toggleTodoCompletion.call(event.id);
      add(LoadUpcomingTodo());

      await Future.delayed(const Duration(seconds: 3));

      Todo? todo = await crudUseCases.readUseCases.getTodo(event.id);

      if (todo!.isDone) {
        await crudUseCases.deleteUseCases.removeTodo.call(todo);
      }

      add(LoadUpcomingTodo());
    });

    on<DateChanged>((event, emit) async {
      add(LoadUpcomingTodo());
    });

    on<UpdateTodoEvent>((event, emit) async {
      await crudUseCases.updateUseCases.updateTodo(event.todo);

      add(LoadUpcomingTodo());
    });
  }

  void _setMidnightTimer() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _setMidnightTimer();
      add(DateChanged());
      // Trigger date change at midnight
    });
  }

  @override
  Future<void> close() {
    _midnightTimer?.cancel();
    return super.close();
  }
}
