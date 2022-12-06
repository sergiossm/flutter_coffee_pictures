// ignore_for_file: lines_longer_than_80_chars

import 'package:coffee_pictures_api/coffee_pictures_api.dart';

/// {@template coffee_pictures_repository}
/// A repository that handles coffee picture related requests.
/// {@endtemplate}
class CoffeePicturesRepository {
  /// {@macro coffee_pictures_repository}
  const CoffeePicturesRepository({required CoffeePicturesApi coffeePicturesApi}) : _coffeePicturesApi = coffeePicturesApi;

  final CoffeePicturesApi _coffeePicturesApi;

  /// Fetches a coffee picture.
  ///
  /// Returns a random coffee picture.
  Future<CoffeePicture> fetchCoffeePicture() => _coffeePicturesApi.fetchCoffeePicture();
}
