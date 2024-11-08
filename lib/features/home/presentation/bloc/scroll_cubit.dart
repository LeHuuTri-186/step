import 'package:flutter_bloc/flutter_bloc.dart';

import 'scroll_state.dart';

class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit() : super(NotScrolled());

  void onScroll(double offset) {
    if (offset > 50) {
      emit(Scrolled());
    } else {
      emit(NotScrolled());
    }
  }
}