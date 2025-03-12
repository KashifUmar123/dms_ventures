import 'package:dartz/dartz.dart';
import 'package:dms_assement/core/constants/endpoints.dart';
import 'package:dms_assement/core/network/dio_wrapper.dart';
import 'package:dms_assement/core/network/failures.dart';
import 'package:dms_assement/core/services/socket_service.dart';

class DriverRepository {
  late SocketService _socketService;
  late IDioWrapper _dioWrapper;

  DriverRepository({
    required SocketService socketService,
    required IDioWrapper dioWrapper,
  }) {
    _socketService = socketService;
    _dioWrapper = dioWrapper;
  }

  Future<Either<Failure, bool>> rejectRide(
    String id,
  ) async {
    try {
      await _dioWrapper.onPost(api: Endpoints.rejectRide(id), data: {});
      return Right(true);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(CustomFailure("Something went wrong"));
      }
    }
  }

  Future<Either<Failure, bool>> acceptRide({
    required String id,
  }) async {
    try {
      await _dioWrapper.onPost(api: Endpoints.acceptRide(id), data: {});
      return Right(true);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(CustomFailure("Something went wrong"));
      }
    }
  }

  Future<Either<Failure, bool>> pickupRider({
    required String id,
  }) async {
    try {
      await _dioWrapper.onPost(api: Endpoints.pickupRider(id), data: {});
      return Right(true);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(CustomFailure("Something went wrong"));
      }
    }
  }

  Future<Either<Failure, bool>> completeRide({
    required String id,
  }) async {
    try {
      await _dioWrapper.onPost(api: Endpoints.completeRide(id), data: {});
      return Right(true);
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      } else {
        return Left(CustomFailure("Something went wrong"));
      }
    }
  }

  void sendMessage({
    required String eventName,
    required Map<String, dynamic> data,
  }) {
    _socketService.sendMessage(eventName: eventName, data: data);
  }
}
