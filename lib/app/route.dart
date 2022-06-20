import 'package:auto_route/annotations.dart';
import 'package:autoly_service/ui/splash/splash_api_view.dart';

@MaterialAutoRouter(
  routes: <AutoRoute>[
    // MaterialRoute(page: SplashScreen, initial: true),
    MaterialRoute(page: SplashApiView, initial: true),
  ],
)
class $Router {}
