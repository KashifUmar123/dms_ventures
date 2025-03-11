import 'dart:developer';

import 'package:dms_assement/core/constants/socket_constants.dart';
import 'package:dms_assement/core/models/rider_request_model.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/repositories/rider/rider_repository.dart';
import 'package:dms_assement/core/utils/app_utils.dart';
import 'package:flutter/material.dart';

class RiderRequestsProvider extends ChangeNotifier {
  final RiderRepository _riderRepository;
  bool isRequestCreating = false;
  RiderRequestResponseModel? riderRequestResponseModel;

  RiderRequestsProvider({
    required RiderRepository riderRepository,
  }) : _riderRepository = riderRepository {
    _identidyAsRider();
    Future.delayed(Duration(seconds: 1), () => getActiveRider());
    getActiveRider();
  }

  Future<void> onCreateRequest(BuildContext context) async {
    if (riderRequestResponseModel != null) {
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
      riderRequestResponseModel = right;
      AppUtils.snackBar(context, right.message);
    });

    isRequestCreating = false;
    notifyListeners();
  }

  Future<void> cancelRequest(BuildContext context) async {
    if (riderRequestResponseModel == null) {
      return;
    }

    final result = await _riderRepository.cancelRequest(
      riderRequestResponseModel?.ride.id,
    );

    result.fold(
      (left) {
        AppUtils.snackBar(context, left.message, isError: true);
      },
      (right) {
        riderRequestResponseModel = null;
        AppUtils.snackBar(context, right.message);
      },
    );

    notifyListeners();
  }

  Future<void> getActiveRider() async {
    final result = await _riderRepository.getActiveRider();
    result.fold(
      (left) {
        log(left.message);
      },
      (right) {},
    );

    notifyListeners();
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
