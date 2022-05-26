import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rec_tasl/core/locator.dart';
import 'package:rec_tasl/core/routes.dart';
import 'package:rec_tasl/providers/crypto_provider.dart';
import 'package:rec_tasl/services/navigation_service.dart';
import 'package:rec_tasl/ui/crypto/crypto_view.dart';

import 'splash/splash_view.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CryptoProvider())],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          navigatorKey: locator<NavigationService>().globalKey,
          onGenerateRoute: Routes.generateRoute,
          builder: (context, child) {
            return ScrollConfiguration(
              behavior: AppScrollBehavior(),
              child: child!,
            );
          },
          home: CryptoView(),
        ),
      ),
    );
  }
}

class AppScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
