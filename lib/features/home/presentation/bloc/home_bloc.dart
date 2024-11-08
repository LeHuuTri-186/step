import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Timer? _midnightTimer;

  HomeBloc()
      : super(HomeState(
          currentDate: DateTime.now(),
          selectedIndex: 0,
        )) {
    _setMidnightTimer();

    on<DateChanged>((event, emit) {
      emit(state.copyWith(currentDate: event.newDate));
      _setMidnightTimer();
    });

    on<IndexChanged>((event, emit) {
      emit(state.copyWith(selectedIndex: event.newIndex));
    });
  }

  void _setMidnightTimer() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final durationUntilMidnight = nextMidnight.difference(now);

    _midnightTimer = Timer(durationUntilMidnight, () {
      _setMidnightTimer();
      add(DateChanged(DateTime.now())); // Trigger date change at midnight
    });
  }

  @override
  Future<void> close() {
    _midnightTimer?.cancel();
    return super.close();
  }
}
