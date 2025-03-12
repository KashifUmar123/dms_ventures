// ignore_for_file: use_build_context_synchronously
import 'dart:developer';
import 'package:dms_assement/core/constants/socket_constants.dart';
import 'package:dms_assement/core/models/rider_request_model.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/routes/app_routes.dart';
import 'package:dms_assement/core/services/socket_service.dart';
import 'package:dms_assement/core/utils/app_utils.dart';
import 'package:dms_assement/main.dart';
import 'package:flutter/material.dart';

class RiderRequestsProvider extends ChangeNotifier {
  final RiderRepository _riderRepository;
  final SocketService _socketService;
  bool isRequestCreating = false;
  Ride? ride;
  RideAcceptResponseModel? rideAcceptResponseModel;

  RiderRequestsProvider({
    required RiderRepository riderRepository,
    required SocketService socketService,
  })  : _riderRepository = riderRepository,
        _socketService = socketService {
    _loadData();
  }

  Future<void> _loadData() async {
    _identidyAsRider();
    await Future.delayed(Duration(seconds: 1));
    getActiveRide();
    listenForEventMessages();
  }

  Future<void> onCreateRequest(BuildContext context) async {
    if (ride != null) {
      AppUtils.snackBar(context, "You have already created a request");
      return;
    }

    RiderRequestModel riderRequestModel = RiderRequestModel(
      pickupLocation: CustomLatlong(latitude: 33.613972, longitude: 73.170286),
      dropoffLocation: CustomLatlong(latitude: 33.596402, longitude: 73.140159),
    );

    isRequestCreating = true;
    notifyListeners();

    final result = await _riderRepository.createRideRequest(riderRequestModel);
    result.fold((left) {
      AppUtils.snackBar(context, left.message, isError: true);
    }, (right) {
      ride = right.ride;
      AppUtils.snackBar(context, right.message);
    });

    isRequestCreating = false;
    notifyListeners();
  }

  Future<void> cancelRequest(BuildContext context) async {
    if (ride == null) {
      return;
    }

    final result = await _riderRepository.cancelRequest(
      ride?.riderId,
    );

    result.fold(
      (left) {
        AppUtils.snackBar(context, left.message, isError: true);
      },
      (right) {
        ride = null;
        AppUtils.snackBar(context, right.message);
      },
    );

    notifyListeners();
  }

  Future<void> getActiveRide() async {
    final result = await _riderRepository.getActive();
    result.fold(
      (left) {
        log(left.message);
      },
      (right) {
        ride = right;
        notifyListeners();
        // navigatorKey.currentState!.pushNamed(
        //   RouteNames.riderMap,
        //   arguments: ride,
        // );
      },
    );
  }

  void listenForEventMessages() {
    BuildContext context = navigatorKey.currentState!.context;
    _socketService.streamController.stream.listen((data) async {
      if (data.event == SocketConstants.RIDE_REJECTED) {
        ride = null;
        AppUtils.snackBar(
          context,
          "Your request has been rejected",
          isError: true,
        );
        notifyListeners();
      }

      if (data.event == SocketConstants.RIDE_ACCEPTED) {
        AppUtils.snackBar(context, "Your request has been accepted");
        rideAcceptResponseModel = RideAcceptResponseModel.fromJson(data.data);
        notifyListeners();
        var result = await navigatorKey.currentState!.pushNamed(
          RouteNames.riderMap,
          arguments: rideAcceptResponseModel,
        );

        if (result != null && result == true) {
          ride = null;
          notifyListeners();
        }
      }

      if (data.event == SocketConstants.RIDE_CANCELLED) {
        AppUtils.snackBar(
          context,
          "Your ride has been cancelled",
          isError: true,
        );
        ride = null;
        notifyListeners();
      }

      if (data.event == SocketConstants.RIDE_COMPLETED) {
        AppUtils.snackBar(
          context,
          "Your ride has been cancelled",
          isError: true,
        );
        ride = null;
        notifyListeners();
      }
    });
  }

  void _identidyAsRider() {
    _riderRepository.sendMessage(
      eventName: SocketConstants.IDENTIFY,
      data: {
        "userType": "rider",
        "location": {"latitude": 33.613972, "longitude": 73.170286}
      },
    );
  }
}
