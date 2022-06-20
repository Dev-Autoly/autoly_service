

import 'package:autoly_service/ui/splash/splash_api_view.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class Routes {
  static const String splashApiView = '/';

  static const all = <String>{
    // splashScreen,
    splashApiView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    //  RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.splashApiView, page: SplashApiView),

  ];

  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{

    SplashApiView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SplashApiView(),
        settings: data,
      );
    },
  };
}