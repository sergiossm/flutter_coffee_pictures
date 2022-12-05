import 'dart:convert';

import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:http/http.dart' as http;

/// {@template http_coffe_pictures_api}
/// A Flutter implementation of the CoffeePicturesApi that uses HTTP.
/// {@endtemplate}
class HttpCoffePicturesApi extends CoffeePicturesApi {
  /// {@macro http_coffe_pictures_api}
  HttpCoffePicturesApi({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const _baseUrlCoffeePictures = 'coffee.alexflipnote.dev/';

  final http.Client _httpClient;

  @override
  Future<CoffeePicture> fetchCoffeePicture() async {
    final coffeePicturesRequest = Uri.https(
      _baseUrlCoffeePictures,
      'random.json',
    );

    final coffeePicturesResponse = await _httpClient.get(coffeePicturesRequest);

    if (coffeePicturesResponse.statusCode != 200) {
      throw CoffeePicturesRequestFailure();
    }

    final bodyJson = jsonDecode(coffeePicturesResponse.body) as Map<String, dynamic>;

    if (!bodyJson.containsKey('file')) {
      throw CoffeePictureFileNotFoundFailure();
    }

    return CoffeePicture.fromJson(bodyJson);
  }
}
