import 'package:dms_assement/core/models/rider_request_model.dart';

class RiderRequestResponseModel {
  final String message;
  final Ride ride;

  RiderRequestResponseModel({
    required this.message,
    required this.ride,
  });

  factory RiderRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return RiderRequestResponseModel(
      message: json['message'] ?? "",
      ride: Ride.fromJson(json['ride']),
    );
  }
}

class Ride {
  final String id;
  final String riderId;
  final String riderName;
  final CustomLatlong pickupLocation;
  final CustomLatlong dropoffLocation;
  final String status;
  final String requestTime;
  final String driverId;
  final String driverName;
  final String acceptTime;

  Ride({
    required this.id,
    required this.riderId,
    required this.riderName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.status,
    required this.requestTime,
    this.driverId = "",
    this.driverName = "",
    this.acceptTime = "",
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      id: json['id'] ?? "",
      riderId: json['riderId'] ?? "",
      riderName: json['riderName'] ?? "",
      pickupLocation: CustomLatlong.fromJson(json['pickupLocation']),
      dropoffLocation: CustomLatlong.fromJson(json['dropoffLocation']),
      status: json['status'] ?? "",
      requestTime: json['requestTime'] ?? "",
      driverId: json['driverId'] ?? "",
      driverName: json['driverName'] ?? "",
      acceptTime: json['acceptTime'] ?? "",
    );
  }
}

class DriverModel {
  final String userId;
  final String name;
  final CustomLatlong location;

  DriverModel({
    required this.userId,
    required this.name,
    required this.location,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      userId: json['userId'] ?? "",
      name: json['name'] ?? "",
      location: CustomLatlong.fromJson(json['location']),
    );
  }
}

class RideAcceptResponseModel {
  final Ride? ride;
  final DriverModel? driver;

  RideAcceptResponseModel({
    this.ride,
    this.driver,
  });

  factory RideAcceptResponseModel.fromJson(Map<String, dynamic> json) {
    return RideAcceptResponseModel(
      ride: json['ride'] != null ? Ride.fromJson(json['ride']) : null,
      driver:
          json['driver'] != null ? DriverModel.fromJson(json['driver']) : null,
    );
  }
}
