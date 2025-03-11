class Endpoints {
  static const String createRideRequest = '/api/rides/request';
  static String acceptRide(String id) => '/api/rides/$id/accept';
  static String rejectRide(String id) => '/api/rides/$id/reject';
  static String pickupRider(String id) => '/api/rides/$id/pickup';
  static String completeRide(String id) => '/api/rides/$id/complete';
  static String cancelRide(String id) => '/api/rides/$id/cancel';
  static String getActiveRider = '/api/rides/active';
}
