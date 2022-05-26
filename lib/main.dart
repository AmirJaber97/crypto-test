import 'package:flutter/material.dart';
import 'package:rec_tasl/ui/app.dart';

import 'core/locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  runApp(Test());
}
