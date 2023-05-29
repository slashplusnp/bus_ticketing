import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../data/data_sources/remote_data_source.dart';
import '../network/app_service_client.dart';
import '../network/dio_factory.dart';
import '../network/network_info.dart';

final getInstance = GetIt.instance;

class DependencyInjection {
  static void initAppModule() {
    getInstance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));
    getInstance.registerLazySingleton<DioFactory>(() => DioFactory());
    final dio = getInstance<DioFactory>().getDio();
    getInstance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));
    getInstance.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(getInstance()));
  }

  static Future<void> reset() async {
    await getInstance.reset(dispose: true);
    initAppModule();
  }
}
