import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/repositories/driver/driver_repository.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:dms_assement/features/commons/map_screen/map_screen.dart';
import 'package:dms_assement/features/commons/map_screen/map_screen_provider.dart';
import 'package:dms_assement/features/driver/driver_request/driver_requests_provider.dart';
import 'package:dms_assement/features/driver/driver_request/driver_requests_screen.dart';
import 'package:dms_assement/features/rider/rider_map/rider_map_provider.dart';
import 'package:dms_assement/features/rider/rider_map/rider_map_screen.dart';
import 'package:dms_assement/features/rider/rider_requests/rider_requests_provider.dart';
import 'package:dms_assement/features/rider/rider_requests/rider_requests_screen.dart';
import 'package:dms_assement/features/splash/splash_screen.dart';
import 'package:dms_assement/features/splash/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RouteNames {
  static const String splash = '/';
  static const String home = '/home';
  static const String riderRequests = '/rider-requests';
  static const String driverRequests = '/driver-requests';
  static const String mapScreen = '/map-screen';
  static const String riderMap = '/rider-map-screen';
  static const String driverMap = '/rider-map-screen';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case RouteNames.splash:
      return MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => SplashScreenProvider(),
            child: SplashScreen(),
          );
        },
      );
    case RouteNames.riderRequests:
      return MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => RiderRequestsProvider(
              riderRepository: locator.get<RiderRepository>(),
              socketService: locator.get<SocketService>(),
            ),
            child: RiderRequestsScreen(),
          );
        },
      );
    case RouteNames.driverRequests:
      return MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => DriverRequestsProvider(
              driverRepository: locator.get<DriverRepository>(),
              socketService: locator.get<SocketService>(),
            ),
            child: DriverRequestsScreen(),
          );
        },
      );

    case RouteNames.mapScreen:
      return MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => MapScreenProvider(),
            child: MapScreen(),
          );
        },
      );
    case RouteNames.riderMap:
      return MaterialPageRoute(
        builder: (_) {
          RideAcceptResponseModel? args;

          if (settings.arguments != null) {
            args = settings.arguments as RideAcceptResponseModel;
          }

          return ChangeNotifierProvider(
            create: (_) => RiderMapProvider(ride: args),
            child: RiderMapScreen(),
          );
        },
      );
    default:
      return MaterialPageRoute(
        builder: (_) {
          return ChangeNotifierProvider(
            create: (_) => SplashScreenProvider(),
            child: SplashScreen(),
          );
        },
      );
  }
}
