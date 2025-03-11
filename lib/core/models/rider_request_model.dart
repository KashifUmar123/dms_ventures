class CustomLatlong {
  final double latitude;
  final double longitude;

  CustomLatlong({required this.latitude, required this.longitude});

  factory CustomLatlong.fromJson(Map<String, dynamic> json) {
    return CustomLatlong(
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}

class RiderRequestModel {
  final CustomLatlong pickupLocation;
  final CustomLatlong dropoffLocation;

  RiderRequestModel({
    required this.pickupLocation,
    required this.dropoffLocation,
  });

  Map<String, dynamic> toJson() {
    return {
      'pickupLocation': {
        'latitude': pickupLocation.latitude,
        'longitude': pickupLocation.longitude,
      },
      'dropoffLocation': {
        'latitude': dropoffLocation.latitude,
        'longitude': dropoffLocation.longitude,
      },
    };
  }

  factory RiderRequestModel.fromJson(Map<String, dynamic> json) {
    return RiderRequestModel(
      pickupLocation: CustomLatlong.fromJson(json['pickupLocation']),
      dropoffLocation: CustomLatlong.fromJson(json['dropoffLocation']),
    );
  }
}
