import 'package:flutter/material.dart';
import 'app_localizations_en.dart';
import 'app_localizations_vie.dart';

class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': AppLocalizationsEn.values,
    'vi': AppLocalizationsVie.values,
  };

  String getString(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}