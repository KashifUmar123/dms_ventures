import 'package:dartz/dartz.dart';
import 'package:dms_assement/core/constants/endpoints.dart';
import 'package:dms_assement/core/models/rider_request_model.dart';
import 'package:dms_assement/core/models/rider_request_response_model.dart';
import 'package:dms_assement/core/network/dio_wrapper.dart';
import 'package:dms_assement/core/network/failures.dart';
import 'package:dms_assement/core/services/socket_service.dart';

class RiderRepository {
  late SocketService _socketService;
  late IDioWrapper _dioWrapper;

  RiderRepository({
    required SocketService socketService,
    required IDioWrapper dioWrapper,
  }) {
    _socketService = socketService;
    _dioWrapper = dioWrapper;
  }

  Future<Either<Failure, RiderRequestResponseModel>> createRideRequest(
    RiderRequestModel requestModel,
  ) async {
    try {
      final response = await _dioWrapper.onPost(
        api: Endpoints.createRideRequest,
        data: requestModel.toJson(),
      );

      return Right(
        RiderRequestResponseModel.fromJson(
          response.data,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CustomFailure('Something went wrong'));
    }
  }

  Future<Either<Failure, RiderRequestResponseModel>> cancelRequest(id) async {
    try {
      final response = await _dioWrapper.onPost(
        api: Endpoints.cancelRide(id),
        data: {
          "userType": "rider",
        },
      );

      return Right(
        RiderRequestResponseModel.fromJson(
          response.data,
        ),
      );
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CustomFailure('Something went wrong'));
    }
  }

  Future<Either<Failure, void>> getActive() async {
    try {
      final response = await _dioWrapper.onGet(
        api: Endpoints.getActiveRider,
      );

      return Right(null);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }
      return Left(CustomFailure('Something went wrong'));
    }
  }

  void sendMessage({
    required String eventName,
    required Map<String, dynamic> data,
  }) {
    _socketService.sendMessage(eventName: eventName, data: data);
  }
}
