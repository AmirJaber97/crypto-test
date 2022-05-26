import 'package:get_it/get_it.dart';
import 'package:rec_tasl/services/api_service.dart';
import 'package:rec_tasl/services/navigation_service.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => ApiService());
}

