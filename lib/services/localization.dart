import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizationsInit {
  final Locale locale;

  AppLocalizationsInit(this.locale);

  static AppLocalizationsInit? of(BuildContext context) {
    return Localizations.of<AppLocalizationsInit>(
        context, AppLocalizationsInit);
  }

  static const LocalizationsDelegate<AppLocalizationsInit> delegate =
      _AppLocalizationsDelegate();

  static List<Locale> get supportedLocales {
    return [
      const Locale('en', ''),
      const Locale('uk', ''),
    ];
  }

  late Map<String, String> _localizedStrings;

  Future<bool> load() async {
    final String jsonString =
        await rootBundle.loadString('lib/l10n/app_${locale.languageCode}.arb');
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return true;
  }

  String? translate(String key) {
    return _localizedStrings[key];
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizationsInit> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'uk'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizationsInit> load(Locale locale) async {
    AppLocalizationsInit localizations = AppLocalizationsInit(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
