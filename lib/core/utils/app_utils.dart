import 'package:dms_assement/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class AppUtils {
  static snackBar(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.only(
        bottom: context.height * .85,
        left: 20,
        right: 20,
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
      content: Text(
        message,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
