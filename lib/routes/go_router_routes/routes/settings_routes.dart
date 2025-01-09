import 'package:bloc_structure/presentation/screen/settings/settings_screen.dart';
import 'package:bloc_structure/routes/app_routes_constants.dart';
import 'package:go_router/go_router.dart';

class SettingsRoutes {
  static final List<GoRoute> routes = [
    GoRoute(name: 'settings', path: ApplicationRoutesConstants.settings, builder: (context, state) => SettingsScreen()),
  ];
}
