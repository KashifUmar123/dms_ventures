import 'package:dms_assement/core/base/user_provider.dart';
import 'package:dms_assement/core/routes/app_routes.dart';
import 'package:flutter/material.dart';

class SplashScreenProvider extends ChangeNotifier {
  void onUserTypeSelected(BuildContext context, UserType userType) {
    if (userType == UserType.rider) {
      Navigator.pushReplacementNamed(context, RouteNames.riderRequests);
    } else {
      Navigator.pushReplacementNamed(context, RouteNames.driverRequests);
    }
  }
}
