abstract class HomeEvent {}

class DateChanged extends HomeEvent {
  final DateTime newDate;

  DateChanged(this.newDate);
}

class IndexChanged extends HomeEvent {
  final int newIndex;

  IndexChanged(this.newIndex);
}