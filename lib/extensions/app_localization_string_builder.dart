import 'package:flutter/cupertino.dart';

import '../lang/app_localizations.dart';

extension LocaleStringBuilder on BuildContext {
  String getLocaleString({required String value}) => AppLocalizations.of(this).getString(value);
}
