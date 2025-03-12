import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvService {
  Future<void> init({String filename = "env/.env"}) async {
    await dotenv.load(fileName: filename);
  }

  String get baseURL => dotenv.env[EnvConstants.baseURL] ?? "";
  String get mapBoxApiKey => dotenv.env[EnvConstants.mapBoxApiKey] ?? "";
}

class EnvConstants {
  static const String baseURL = "BASE_URL";
  static const String mapBoxApiKey = "MAPBOX_API_KEY";
}
