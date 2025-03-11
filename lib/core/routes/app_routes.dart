import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/repositories/driver/driver_repository.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:dms_assement/features/driver/driver_request/driver_requests_provider.dart';
import 'package:dms_assement/features/driver/driver_request/driver_requests_screen.dart';
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
