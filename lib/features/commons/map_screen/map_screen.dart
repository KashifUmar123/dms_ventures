import 'package:dms_assement/core/extensions/context_extension.dart';
import 'package:dms_assement/features/commons/map_screen/map_screen_provider.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: context.height,
        width: context.width,
        child: Consumer<MapScreenProvider>(
          builder: (_, provider, __) {
            return Stack(
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
              ],
            );
          },
        ),
      ),
    );
  }
}
