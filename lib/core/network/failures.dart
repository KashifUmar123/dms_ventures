abstract class Failure {
  final String message;

  Failure(this.message);

  @override
  String toString() {
    return message;
  }
}

class CustomFailure extends Failure {
  CustomFailure(super.message);
}

class ServerFailure extends Failure {
  ServerFailure(String s) : super('Server Failure');
}

class ResourceNotFound extends Failure {
  ResourceNotFound() : super('Not Found Failure');
}

class NoInternetFailure extends Failure {
  NoInternetFailure() : super("No internet connection");
}

class AutorizationFailure extends Failure {
  AutorizationFailure() : super('Autorization Failure');
}

class DioBadRequest extends Failure {
  DioBadRequest({required String message}) : super(message);
}

class DioUnAuthorized extends Failure {
  DioUnAuthorized({required String message}) : super(message);
}

class DioNotFoundError extends Failure {
  DioNotFoundError({required String message}) : super(message);
}

class DioTimeoutError extends Failure {
  DioTimeoutError({required String message}) : super(message);
}

class ServiceUnavailableFailure extends Failure {
  ServiceUnavailableFailure({required String message}) : super(message);
}

class DioDefaultFailure extends Failure {
  DioDefaultFailure({required String message}) : super(message);
}
