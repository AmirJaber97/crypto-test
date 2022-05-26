import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rec_tasl/constants/route_paths.dart';
import 'package:rec_tasl/constants/strings.dart';
import 'package:rec_tasl/ui/crypto/crypto_view.dart';
import 'package:rec_tasl/ui/splash/splash_view.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.Splash:
        return CupertinoPageRoute(builder: (_) => SplashView());
      case RoutePaths.Crypto:
        return CupertinoPageRoute(builder: (_) => CryptoView());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('${AppStrings.noRouteDefined} ${settings.name}'),
                  ),
                ));
    }
  }
}
