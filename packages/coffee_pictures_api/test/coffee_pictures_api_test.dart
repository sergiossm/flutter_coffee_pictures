import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:test/test.dart';

class TestCoffeePicturesApi extends CoffeePicturesApi {
  TestCoffeePicturesApi() : super();

  @override
  dynamic noSuchMethod(Invocation invocation) {
    return super.noSuchMethod(invocation);
  }
}

void main() {
  group('CoffeePicturesApi', () {
    test('can be constructed', () {
      expect(TestCoffeePicturesApi.new, returnsNormally);
    });
  });
}
