import 'package:dms_assement/core/base/user_provider.dart';
import 'package:dms_assement/features/splash/splash_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Consumer<SplashScreenProvider>(
          builder: (_, provider, __) {
            return Consumer<UserProvider>(
              builder: (_, userProvider, __) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text("Splash Screen"),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.setUserType(UserType.driver);
                        provider.onUserTypeSelected(context, UserType.driver);
                      },
                      child: const Text("Continue as a driver"),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.setUserType(UserType.rider);
                        provider.onUserTypeSelected(context, UserType.rider);
                      },
                      child: const Text("Continue as a rider"),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
