// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert';
import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/services/direction_service.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as gl;
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class MapScreenProvider extends ChangeNotifier {
  MapboxMap? mapboxMap;
  final DirectionService _directionService = locator.get<DirectionService>();

  void onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    // await asksPermission();
    mapboxMap?.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    ));
    Timer(const Duration(seconds: 1), () {
      createRoute();
    });
    notifyListeners();
  }

  Future<void> asksPermission() async {
    var status = await Permission.location.request();

    if (status.isGranted) {
      debugPrint("Location permission granted");
      checkGeoLocatorPersmissions();
    } else if (status.isDenied) {
      debugPrint("Location permission denied");
    } else if (status.isPermanentlyDenied) {
      debugPrint("Location permission permanently denied");
      openAppSettings();
    }
  }

  void checkGeoLocatorPersmissions() async {
    bool isServiceEnabled = false;
    gl.LocationPermission permission = gl.LocationPermission.denied;

    isServiceEnabled = await gl.Geolocator.isLocationServiceEnabled();

    if (!isServiceEnabled) {
      isServiceEnabled = await gl.Geolocator.openLocationSettings();
    }

    permission = await gl.Geolocator.checkPermission();
    if (permission == gl.LocationPermission.deniedForever) {
      openAppSettings();
    } else if (permission == gl.LocationPermission.denied) {
      await gl.Geolocator.requestPermission();
    } else {
      _listenToPositionChanges();
    }
  }

  void _listenToPositionChanges() {
    gl.LocationSettings locationSettings = gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 10,
    );

    gl.Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((position) {
      debugPrint(position.toString());
      if (mapboxMap != null) {
        mapboxMap!.flyTo(
          CameraOptions(
            zoom: 15,
            center: Point(
              coordinates: Position(position.longitude, position.latitude),
            ),
          ),
          MapAnimationOptions(duration: 1000, startDelay: 0),
        );
      }
    });
  }

  Map<String, dynamic> createGeoJsonFromPoints(List<Position> points) {
    // Convert the list of Position objects to a list of coordinate arrays
    final coordinates = points.map((point) => [point.lng, point.lat]).toList();

    // Create the GeoJSON structure
    return {
      "type": "Feature",
      "geometry": {
        "type": "LineString",
        "coordinates": coordinates,
      },
      "properties": {}, // Optional properties
    };
  }

  Future<void> createRoute() async {
    try {
      final result = await _directionService.getRoute(
        Position(73.169094, 33.616463),
        Position(73.137808, 33.597963),
      );

      drawRoute(result);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void drawRoute(List<Position> route) async {
    if (mapboxMap == null) return;

    try {
      final lineString = LineString(coordinates: route);

      // Debug: Print the LineString coordinates
      debugPrint('LineString coordinates: ${lineString.coordinates}');

      final feature = Feature(id: "feature_1", geometry: lineString);
      final featureJson = feature.toJson();

      // Debug: Print the Feature JSON
      debugPrint('Feature JSON: $featureJson');

      await mapboxMap?.style.addSource(
        GeoJsonSource(
          id: 'route-source', // Unique ID for the source
          data: json.encode(featureJson), // Convert to JSON string
        ),
      );

      await mapboxMap?.style.addLayer(
        LineLayer(
          id: 'route-layer',
          sourceId: 'route-source',
          lineColor: Colors.red.value,
          lineWidth: 5.0,
          lineOpacity: 1.0,
        ),
      );

      debugPrint('Route source and layer added successfully.');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
