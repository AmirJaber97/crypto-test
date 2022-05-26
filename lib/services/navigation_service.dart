import 'package:flutter/material.dart';

class NavigationService {
  final GlobalKey<NavigatorState> _globalKey = GlobalKey<NavigatorState>();

  GlobalKey<NavigatorState> get globalKey => _globalKey;

  GlobalKey<NavigatorState> getKey(int? key) {
    switch (key) {
      default:
        return globalKey;
    }
  }

  Future<dynamic> pushTo(Widget page) {
    return globalKey.currentState!.push(MaterialPageRoute(builder: (ctx) => page));
  }

  Future<dynamic> navigateTo(String routeName, {Object? arguments, int? key}) {
    return key == null
        ? _globalKey.currentState!.pushNamed(routeName, arguments: arguments)
        : getKey(key).currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateWithReplacementTo(String routeName, {Object? arguments, int? key}) {
    return key == null
        ? _globalKey.currentState!.pushReplacementNamed(routeName, arguments: arguments)
        : getKey(key).currentState!.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic> navigateAndRemoveStack(String route, {Object? arguments, int? key}) {
    return key == null
        ? _globalKey.currentState!.pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false, arguments: arguments)
        : getKey(key)
            .currentState!
            .pushNamedAndRemoveUntil(route, (Route<dynamic> route) => false, arguments: arguments);
  }

  void goBack({List? res, int? key}) {
    return key == null ? globalKey.currentState!.pop(res) : getKey(key).currentState!.pop(res);
  }
}
