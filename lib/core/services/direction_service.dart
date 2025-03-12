import 'dart:developer';
import 'package:dms_assement/core/network/dio_wrapper.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

class DirectionService {
  static const String baseUrl =
      'https://api.mapbox.com/directions/v5/mapbox/driving';
  final String accessToken;
  final IDioWrapper _dioWrapper;

  DirectionService({
    required this.accessToken,
    required IDioWrapper dioWrapper,
  }) : _dioWrapper = dioWrapper;

  Future<List<Position>> getRoute(Position start, Position end) async {
    final url =
        '$baseUrl/${start.lng},${start.lat};${end.lng},${end.lat}?geometries=geojson&access_token=$accessToken';

    final response = await _dioWrapper.onGet(api: url);

    if (response.statusCode == 200) {
      final data = response.data;
      final coordinates = data['routes'][0]['geometry']['coordinates'];
      log('Route: ${data['routes'][0]['geometry']['coordinates']}');
      return coordinates
          .map<Position>((coord) => Position(coord[0], coord[1]))
          .toList();
    } else {
      throw Exception('Failed to load route');
    }
  }
}
