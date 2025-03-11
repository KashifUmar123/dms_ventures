import 'package:dms_assement/core/extensions/context_extension.dart';
import 'package:dms_assement/core/widgets/custom_button.dart';
import 'package:dms_assement/features/driver/driver_request/driver_requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DriverRequestsScreen extends StatelessWidget {
  const DriverRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DriverRequestsProvider>(
      builder: (_, provider, __) {
        return SizedBox(
          height: context.height,
          width: context.width,
          child: Scaffold(
            body: Column(
              children: [
                SizedBox(height: context.paddingTop),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "Rider Requests",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      if (provider.requests.isEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 300),
                          child: Text("No requests available"),
                        ),
                      ...provider.requests.map((e) {
                        return Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: .5),
                                spreadRadius: 1,
                                blurRadius: 7,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Rider Name: ",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(e.riderName),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      text: "Reject",
                                      backgroundColor: Colors.red,
                                      onPressed: () {
                                        provider.rejectRide(context);
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: CustomButton(
                                      text: "Accept",
                                      onPressed: () {
                                        provider.acceptRide(context);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
