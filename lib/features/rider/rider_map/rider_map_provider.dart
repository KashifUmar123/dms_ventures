import 'dart:async';
import 'dart:developer';
import 'package:dms_assement/core/constants/socket_constants.dart';
import 'package:dms_assement/core/extensions/map_extension.dart';
import 'package:dms_assement/core/locator/locator.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/services/direction_service.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:dms_assement/core/utils/app_utils.dart';
import 'package:dms_assement/main.dart';
import 'package:flutter/material.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart' as gl;

class RiderMapProvider extends ChangeNotifier {
  MapboxMap? mapboxMap;
  final DirectionService _directionService = locator.get<DirectionService>();
  final SocketService _socketService = locator.get<SocketService>();
  final RiderRepository _riderRepository = locator.get<RiderRepository>();
  StreamSubscription? _positionStreamSubscription;
  bool isCancelling = false;
  RideAcceptResponseModel? ride;

  RiderMapProvider({this.ride}) {
    _listenToEventMessages();
  }

  void _listenToEventMessages() {
    _socketService.streamController.stream.listen((data) async {
      if (data.event == SocketConstants.RIDE_PICKED_UP) {
        log("Ride Picked Up");
        await mapboxMap?.removeRoute();
        createRouteBetweenPickAndDrop();
      } else if (data.event == SocketConstants.RIDE_CANCELLED) {
        log("Ride Cancelled");
        await mapboxMap?.removeRoute();
        navigatorKey.currentState?.pop();
      } else if (data.event == SocketConstants.RIDE_COMPLETED) {
        log("Ride Completed");
        await mapboxMap?.removeRoute();
        navigatorKey.currentState?.pop();
        AppUtils.snackBar(navigatorKey.currentContext!, "Ride Completed");
      }
    });
  }

  void createRouteBetweenRiderAndDriver() async {
    // Get the route between the driver and the rider
    // Draw the route on the map

    try {
      if (mapboxMap == null) return;
      // first create route
      final route = await _directionService.getRoute(
        Position(
          ride!.driver!.location.longitude,
          ride!.driver!.location.latitude,
        ),
        Position(
          ride!.ride!.pickupLocation.longitude,
          ride!.ride!.pickupLocation.latitude,
        ),
      );

      // Draw the route on the map
      mapboxMap?.drawRoute(route);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void createRouteBetweenPickAndDrop() async {
    // Get the route between the driver and the rider
    // Draw the route on the map

    try {
      if (mapboxMap == null) return;
      // first create route
      final route = await _directionService.getRoute(
        Position(
          ride!.ride!.pickupLocation.longitude,
          ride!.ride!.pickupLocation.latitude,
        ),
        Position(
          ride!.ride!.dropoffLocation.longitude,
          ride!.ride!.dropoffLocation.latitude,
        ),
      );

      // Draw the route on the map
      mapboxMap?.drawRoute(route);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    mapboxMap?.location.updateSettings(LocationComponentSettings(
      enabled: true,
      pulsingEnabled: true,
    ));

    _askPermissions(() {
      // Check if the rider status is picked up, then no need to listen to the changes.
      // _listenToPositionChanges();
      createRouteBetweenRiderAndDriver();
    });

    notifyListeners();
  }

  void _askPermissions(VoidCallback callback) async {
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
      callback();
    }
  }

  void _listenToPositionChanges() {
    gl.LocationSettings locationSettings = gl.LocationSettings(
      accuracy: gl.LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionStreamSubscription =
        gl.Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((position) {
      debugPrint(position.toString());
      if (mapboxMap != null) {
        // mapboxMap!.flyTo(
        //   CameraOptions(
        //     zoom: 15,
        //     center: Point(
        //       coordinates: Position(position.longitude, position.latitude),
        //     ),
        //   ),
        //   MapAnimationOptions(duration: 1000, startDelay: 0),
        // );

        _socketService.sendMessage(
          eventName: SocketConstants.UPDATE_LOCATION,
          data: {
            "userType": "rider",
            "location": {
              "latitude": position.latitude,
              "longitude": position.longitude,
            }
          },
        );
      }
    });
  }

  Future<void> cancelRide() async {
    if (ride == null) {
      return;
    }

    isCancelling = true;
    notifyListeners();

    BuildContext context = navigatorKey.currentContext!;

    final result = await _riderRepository.cancelRequest(
      ride?.ride?.id,
    );

    result.fold(
      (left) {
        AppUtils.snackBar(context, left.message, isError: true);
      },
      (right) {
        ride = null;
        navigatorKey.currentState?.pop(true);
        AppUtils.snackBar(context, right.message);
      },
    );

    isCancelling = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    super.dispose();
  }
}
