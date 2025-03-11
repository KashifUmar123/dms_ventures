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

  Ride({
    required this.id,
    required this.riderId,
    required this.riderName,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.status,
    required this.requestTime,
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
    );
  }
}
