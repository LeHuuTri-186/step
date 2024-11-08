import 'package:step/features/home/domain/usecases/create/create_usecases.dart';
import 'package:step/features/home/domain/usecases/delete/delete_usecases.dart';
import 'package:step/features/home/domain/usecases/read/read_usecases.dart';
import 'package:step/features/home/domain/usecases/update/update_usecases.dart';

class CrudUseCases {
  final CreateUseCases createUseCases;
  final ReadUseCases readUseCases;
  final UpdateUseCases updateUseCases;
  final DeleteUseCases deleteUseCases;

  CrudUseCases({required this.createUseCases, required this.readUseCases, required this.updateUseCases, required this.deleteUseCases});
}