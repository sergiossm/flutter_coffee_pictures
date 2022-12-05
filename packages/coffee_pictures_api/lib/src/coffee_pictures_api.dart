import 'package:coffee_pictures_api/coffee_pictures_api.dart';

/// {@template coffee_pictures_api}
/// The interface and models for an API providing access to coffee pictures.
/// {@endtemplate}
abstract class CoffeePicturesApi {
  /// {@macro coffee_pictures_api}
  const CoffeePicturesApi();

  /// Fetches a coffe picture.
  ///
  /// Returns a random coffee picture.
  Future<CoffeePicture> fetchCoffeePicture();
}
