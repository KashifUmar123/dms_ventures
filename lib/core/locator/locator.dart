import 'package:dio/dio.dart';
import 'package:dms_assement/core/constants/app_constatns.dart';
import 'package:dms_assement/core/network/dio_wrapper.dart';
import 'package:dms_assement/core/repositories/driver/driver_repository.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/services/direction_service.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:get_it/get_it.dart';

final GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<IDioWrapper>(
    () => DioWrapperImp(
      Dio(
        BaseOptions(
          baseUrl: AppConstatns.baseUrl,
          connectTimeout: Duration(seconds: 10),
          receiveTimeout: Duration(seconds: 10),
        ),
      ),
    ),
  );

  locator.registerLazySingleton(
    () => SocketService(),
  );

  locator.get<SocketService>().connect();

  locator.registerLazySingleton<RiderRepository>(
    () => RiderRepository(
      socketService: locator.get<SocketService>(),
      dioWrapper: locator.get<IDioWrapper>(),
    ),
  );

  locator.registerLazySingleton<DriverRepository>(
    () => DriverRepository(
      socketService: locator.get<SocketService>(),
      dioWrapper: locator.get<IDioWrapper>(),
    ),
  );

  locator.registerLazySingleton(
    () => DirectionService(
      accessToken: AppConstatns.mapboxAPIKey,
      dioWrapper: locator.get<IDioWrapper>(),
    ),
  );
}
