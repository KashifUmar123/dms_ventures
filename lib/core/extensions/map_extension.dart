// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:dms_assement/core/constants/app_constatns.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

extension MapExtension on MapboxMap {
  Future<void> drawRoute(
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
          lineColor: Colors.green.value,
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

  Future<PointAnnotation> addMarkerImage(
    Position position, {
    required PointAnnotationManager pointAnnotationManager,
  }) async {
    // Load the image from assets
    final ByteData bytes = await rootBundle.load(AppConstatns.markerIcon);
    final Uint8List imageData = bytes.buffer.asUint8List();

    // Create a PointAnnotationOptions
    PointAnnotationOptions pointAnnotationOptions = PointAnnotationOptions(
      geometry: Point(coordinates: position),
      image: imageData,
      iconSize: .25,
    );

    // Add the annotation to the map
    return await pointAnnotationManager.create(pointAnnotationOptions);
  }

  // remove markers
  Future<void> removeMarker(
    PointAnnotation marker, {
    required PointAnnotationManager pointAnnotationManager,
  }) async {
    try {
      await pointAnnotationManager.delete(marker);
      debugPrint('Marker removed successfully.');
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<PointAnnotation> updateMarker(
    PointAnnotation marker, {
    required PointAnnotationManager pointAnnotationManager,
    required Position position,
  }) async {
    try {
      await removeMarker(
        marker,
        pointAnnotationManager: pointAnnotationManager,
      );

      return await addMarkerImage(
        position,
        pointAnnotationManager: pointAnnotationManager,
      );
    } catch (e) {
      debugPrint(e.toString());
      return marker;
    }
  }
}
