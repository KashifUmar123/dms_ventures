/*

## WebSocket Events

### Client to Server

- `identify` - Identify as driver or rider
  ```json
  {
    "userType": "driver", // or "rider"
    "location": {
      "latitude": 24.7749,
      "longitude": 42.4194
    }
  }
  ```

- `updateLocation` - Update user location
  ```json
  {
    "userType": "driver", // or "rider"
    "location": {
      "latitude": 24.7749,
      "longitude": 42.4194
    }
  }
  ```

### Server to Client

- `rideRequest` - New ride request (to driver)
- `rideAccepted` - Ride accepted notification (to rider)
- `ridePickedUp` - Rider picked up notification
- `rideCompleted` - Ride completed notification
- `rideCancelled` - Ride cancelled notification
- `driverLocationUpdate` - Driver location update (to rider)

## Note

*/

class SocketConstants {
  // CLIENT TO SERVER
  static const String IDENTIFY = 'identify';
  static const String UPDATE_LOCATION = 'updateLocation';

  // SERVER TO CLIENT
  static const String RIDE_REQUEST = 'rideRequest';
  static const String RIDE_ACCEPTED = 'rideAccepted';
  static const String RIDE_REJECTED = 'rideRejected';
  static const String RIDE_PICKED_UP = 'ridePickedUp';
  static const String RIDE_COMPLETED = 'rideCompleted';
  static const String RIDE_CANCELLED = 'rideCancelled';
  static const String DRIVER_LOCATION_UPDATE = 'driverLocationUpdate';
}
