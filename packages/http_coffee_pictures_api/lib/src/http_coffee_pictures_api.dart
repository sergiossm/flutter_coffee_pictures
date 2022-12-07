// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:convert';

import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:http/http.dart' as http;

/// {@template http_cofee_pictures_api}
/// A Flutter implementation of the CoffeePicturesApi that uses HTTP.
/// {@endtemplate}
class HttpCoffeePicturesApi extends CoffeePicturesApi {
  /// {@macro http_cofee_pictures_api}
  HttpCoffeePicturesApi({http.Client? httpClient}) : _httpClient = httpClient ?? http.Client();

  static const _baseUrlCoffeePictures = 'coffee.alexflipnote.dev';

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

  @override
  Future<List<int>> downloadCoffeePicture({required String url}) async {
    final request = http.Request('GET', Uri.parse(url));
    final response = await _httpClient.send(request);

    final bytes = <int>[];
    late StreamSubscription<List<int>> subscription;
    subscription = response.stream.listen(
      bytes.addAll,
      onDone: () {
        subscription.cancel();
      },
    );
    return subscription.asFuture(bytes);
  }
}
