// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension MapExtension on MapboxMap {
  void drawRoute(
    List<Position> route, {
    String lineId = 'route-layer',
    String geoJsonId = 'route-source',
    String featureId = 'feature_1',
  }) async {
    try {
      final lineString = LineString(coordinates: route);

      // Debug: Print the LineString coordinates
      debugPrint('LineString coordinates: ${lineString.coordinates}');

      final feature = Feature(id: featureId, geometry: lineString);
      final featureJson = feature.toJson();

      // Debug: Print the Feature JSON
      debugPrint('Feature JSON: $featureJson');

      await style.addSource(
        GeoJsonSource(
          id: geoJsonId,
          data: json.encode(featureJson),
        ),
      );

      await style.addLayer(
        LineLayer(
          id: lineId,
          sourceId: geoJsonId,
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

  Future<void> removeRoute({
    String lineId = 'route-layer',
    String geoJsonId = 'route-source',
    String featureId = 'feature_1',
  }) async {
    try {
      await style.removeStyleLayer(lineId);
      await style.removeStyleSource(geoJsonId);
      debugPrint('Route source and layer removed successfully.');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
