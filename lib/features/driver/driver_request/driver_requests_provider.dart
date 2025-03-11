import 'package:dms_assement/core/constants/socket_constants.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/repositories/driver/driver_repository.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:dms_assement/core/utils/app_utils.dart';
import 'package:flutter/material.dart';

class DriverRequestsProvider extends ChangeNotifier {
  final DriverRepository _driverRepository;
  final SocketService _socketService;

  DriverRequestsProvider({
    required DriverRepository driverRepository,
    required SocketService socketService,
  })  : _driverRepository = driverRepository,
        _socketService = socketService {
    _identidyAsDriver();
    listenForEventMessages();
  }

  List<Ride> requests = [];

  void listenForEventMessages() {
    _socketService.streamController.stream.listen((data) {
      if (data.event == SocketConstants.RIDE_REQUEST) {
        requests = [Ride.fromJson(data.data)];
        notifyListeners();
      }

      if (data.event == SocketConstants.RIDE_CANCELLED) {
        requests = [];
        notifyListeners();
      }
    });
  }

  Future<void> rejectRide(BuildContext context) async {
    final result = await _driverRepository.rejectRide(requests.first.id);
    result.fold((left) {
      AppUtils.snackBar(context, left.message, isError: true);
    }, (right) {
      requests = [];
      notifyListeners();
    });
  }

  Future<void> acceptRide(BuildContext context) async {
    final result = await _driverRepository.acceptRide(id: requests.first.id);
    result.fold((left) {
      AppUtils.snackBar(context, left.message, isError: true);
    }, (right) {
      requests = [];
      notifyListeners();
      AppUtils.snackBar(context, "Ride accepted successfully");
    });
  }

  void _identidyAsDriver() {
    _driverRepository.sendMessage(
      eventName: SocketConstants.IDENTIFY,
      data: {
        "userType": "driver",
        "location": {"latitude": 33.613972, "longitude": 73.170286}
      },
    );
  }
}
