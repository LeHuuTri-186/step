import 'package:step/core/usecases/usecase.dart';
import 'package:intl/intl.dart';

class ValidateTodo extends SyncUseCase<String?, String?> {

  @override
  String? call(String? params) {
    if (params == null || params.trim().isEmpty) {
      return 'invalidTitle';
    }

    return null;
  }
}

class ValidateDate extends SyncUseCase<String?, String?> {

  @override
  String? call(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a date';
    }
    if (!_isValidDate(value)) {
      return 'Enter a valid date (dd/MM/yyyy)';
    }

    return null;
  }

  bool _isValidDate(String date) {
    try {
      final parsedDate = DateFormat('dd/MM/yyyy').parseStrict(date);
      return true;
    } catch (e) {
      return false;
    }
  }
}