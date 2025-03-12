import 'package:dms_assement/core/extensions/context_extension.dart';
import 'package:dms_assement/core/extensions/map_extension.dart';
import 'package:dms_assement/core/widgets/custom_button.dart';
import 'package:dms_assement/features/rider/rider_map/rider_map_provider.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

class RiderMapScreen extends StatelessWidget {
  const RiderMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RiderMapProvider>(
      builder: (_, provider, __) {
        return Scaffold(
          body: SizedBox(
            height: context.height,
            width: context.width,
            child: Stack(
              children: [
                Positioned.fill(
                  child: MapWidget(
                    key: ValueKey("mapWidget"),
                    onMapCreated: provider.onMapCreated,
                    styleUri: MapboxStyles.MAPBOX_STREETS,
                    cameraOptions: CameraOptions(
                      center: Point(
                        coordinates: Position(73.174012, 33.614713),
                      ),
                      zoom: 15.0,
                    ),
                  ),
                ),
                if (provider.showCancelRideButton)
                  Positioned(
                    bottom: 0,
                    child: _buildCancelRiderWidget(context, provider),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCancelRiderWidget(
    BuildContext context,
    RiderMapProvider provider,
  ) {
    return Container(
      width: context.width,
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: SizedBox(
        width: context.width * .8,
        child: Center(
          child: CustomButton(
            text: "Cancel Ride",
            onPressed: provider.cancelRide,
            isLoading: provider.isCancelling,
          ),
        ),
      ),
    );
  }
}
