import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:flutter/material.dart';

enum UserType { rider, driver, none }

class UserProvider extends ChangeNotifier {
  final SocketService _socketService = locator.get<SocketService>();
  UserType _userType = UserType.none;

  UserType get userType => _userType;

  void setUserType(UserType userType) {
    _userType = userType;
    notifyListeners();
  }

  UserProvider() {
    _socketService.reconnectController.stream.listen((data) {
      if (_userType != UserType.none) {
        _socketService.sendMessage(
          eventName: 'identify',
          data: {
            "userType": _userType.name,
            "location": {"latitude": 33.613972, "longitude": 73.170286}
          },
        );
      }
    });
  }
}
