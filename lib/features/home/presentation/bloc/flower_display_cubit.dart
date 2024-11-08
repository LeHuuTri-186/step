import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:step/core/utils/flower_path_util.dart';

class FlowerDisplayCubit extends Cubit<String> {
  FlowerDisplayCubit() : super(FlowerPath.blueFlower);

  final _random = Random();

  void onDisplay() {
    int randomUpperBound = FlowerPath.flowers.length;
    emit(FlowerPath.flowers[_random.nextInt(randomUpperBound)]);
  }
}