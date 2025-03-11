import 'package:dms_assement/core/base/user_provider.dart';
import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  runApp(const DMSVenturesApp());
}

class DMSVenturesApp extends StatelessWidget {
  const DMSVenturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: Consumer<UserProvider>(
        builder: (_, value, __) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'DMS Ventures',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            initialRoute: RouteNames.home,
            onGenerateRoute: onGenerateRoute,
          );
        },
      ),
    );
  }
}
