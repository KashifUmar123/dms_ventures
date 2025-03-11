import 'package:flutter/material.dart';

enum UserType { rider, driver, none }

class UserProvider extends ChangeNotifier {
  UserType _userType = UserType.none;

  UserType get userType => _userType;

  void setUserType(UserType userType) {
    _userType = userType;
    notifyListeners();
  }

  void showUserTypeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Select User Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Rider'),
                onTap: () {
                  setUserType(UserType.rider);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text('Driver'),
                onTap: () {
                  setUserType(UserType.driver);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
