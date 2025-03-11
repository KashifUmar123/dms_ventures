import 'package:dms_assement/core/extensions/context_extension.dart';
import 'package:dms_assement/core/routes/app_routes.dart';
import 'package:dms_assement/core/widgets/custom_button.dart';
import 'package:dms_assement/features/rider/rider_requests/rider_requests_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RiderRequestsScreen extends StatelessWidget {
  const RiderRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderRequestsProvider>(
      builder: (_, provider, __) {
        return Scaffold(
          body: SizedBox(
            height: context.height * 1,
            width: context.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Column(
                    children: [
                      SizedBox(height: context.paddingTop),
                      Text(
                        "Rider Requests",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: context.height * .2),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: _buildRequestWidget(context, provider),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestWidget(
    BuildContext context,
    RiderRequestsProvider provider,
  ) {
    return Container(
      height: context.height * .2,
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: .5),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(height: 20),
          Text(
            "Create a request",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          CustomButton(
            onPressed: () {
              if (provider.ride != null) {
                provider.cancelRequest(context);
              } else {
                provider.onCreateRequest(context);
              }
            },
            text: provider.ride == null ? "Create Request" : "Cancel Request",
            isLoading: provider.isRequestCreating,
          ),
          SizedBox(height: 10),
          CustomButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RouteNames.mapScreen);
            },
            text: "Go to Map",
          ),
        ],
      ),
    );
  }
}
