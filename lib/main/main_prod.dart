import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bloc_structure/configuration/app_logger.dart';
import 'package:bloc_structure/configuration/environment.dart';
import 'package:bloc_structure/configuration/local_storage.dart';
import 'package:bloc_structure/routes/app_router.dart';

import 'app.dart';
import 'main_prod.mapper.g.dart' show initializeJsonMapper;

/// IMPORTANT!! run this command to generate main_prod.mapper.g.dart
// dart run build_runner build --delete-conflicting-outputs
// flutter pub run intl_utils:generate
/// main entry point of PRODUCTION
void main() async {
  // first configure the logger
  AppLogger.configure(isProduction: false);
  final log = AppLogger.getLogger("main_prod.dart");

  ProfileConstants.setEnvironment(Environment.prod);

  log.info("Starting App with env: {}", [Environment.prod.name]);

  initializeJsonMapper();
  WidgetsFlutterBinding.ensureInitialized();

  const defaultLanguage = "en";
  AppLocalStorage().setStorage(StorageType.sharedPreferences);
  await AppLocalStorage().save(StorageKeys.language.name, defaultLanguage);

  AppRouter().setRouter(RouterType.goRouter);

  WidgetsFlutterBinding.ensureInitialized();
  const initialTheme = AdaptiveThemeMode.dark;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(const App(language: defaultLanguage, initialTheme: initialTheme));
  });

  //TODO change to the system theme(browser theme)
  final defaultThemeName = initialTheme.name;
  await AppLocalStorage().save(StorageKeys.theme.name, defaultThemeName);

  log.info("Started App with local environment language: {} and theme: {}", [defaultLanguage, defaultThemeName]);
}
