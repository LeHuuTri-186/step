class HomeState {
  HomeState({required this.selectedIndex, required this.currentDate});

  final DateTime currentDate;
  final int selectedIndex;

  HomeState copyWith({
    DateTime? currentDate,
    int? selectedIndex,
  }) {
    return HomeState(
      currentDate: currentDate ?? this.currentDate,
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}
