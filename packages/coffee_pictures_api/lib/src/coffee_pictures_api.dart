// ignore_for_file: lines_longer_than_80_chars

import 'package:coffee_pictures_api/coffee_pictures_api.dart';

/// Exception thrown when fetchCoffeePicture fails.
class CoffeePicturesRequestFailure implements Exception {}

/// Exception thrown when file for a coffee picture is not found.
class CoffeePictureFileNotFoundFailure implements Exception {}

/// {@template coffee_pictures_api}
/// The interface and models for an API providing access to coffee pictures.
/// {@endtemplate}
abstract class CoffeePicturesApi {
  /// {@macro coffee_pictures_api}
  const CoffeePicturesApi();

  /// Fetches a coffee picture.
  ///
  /// Returns a random coffee picture.
  Future<CoffeePicture> fetchCoffeePicture();

  /// Downloads a coffee picture
  ///
  ///
  Future<List<int>> downloadCoffeePicture({required String url});
}
