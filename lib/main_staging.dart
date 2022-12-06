import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_pictures/bootstrap.dart';
import 'package:http_coffee_pictures_api/http_coffee_pictures_api.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  bootstrap(coffeePicturesApi: HttpCoffeePicturesApi());
}
