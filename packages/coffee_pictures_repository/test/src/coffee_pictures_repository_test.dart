import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCoffeePicturesApi extends Mock implements CoffeePicturesApi {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

void main() {
  group(
    'MockCoffeePicturesRepository',
    () {
      late CoffeePicturesApi coffeePicturesApi;
      late CoffeePicturesRepository coffeePicturesRepository;

      setUp(() {
        coffeePicturesApi = MockCoffeePicturesApi();
        coffeePicturesRepository = CoffeePicturesRepository(
          coffeePicturesApi: coffeePicturesApi,
        );
      });

      CoffeePicturesRepository createSubject() => CoffeePicturesRepository(
            coffeePicturesApi: coffeePicturesApi,
          );

      group('constructor', () {
        test('works properly', () {
          expect(
            createSubject,
            returnsNormally,
          );
        });
      });

      group(
        'fetchCoffeePicture',
        () {
          const file = 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg';

          test('makes correct api request', () async {
            final coffeePicture = MockCoffeePicture();
            when(() => coffeePicture.file).thenReturn(file);
            when(() => coffeePicturesApi.fetchCoffeePicture()).thenAnswer(
              (_) async => coffeePicture,
            );
            try {
              await coffeePicturesRepository.fetchCoffeePicture();
            } catch (_) {}
            verify(
              () => coffeePicturesApi.fetchCoffeePicture(),
            ).called(1);
          });

          test('throws when fetchCoffeePicture fails', () async {
            final exception = Exception('oops');
            when(() => coffeePicturesApi.fetchCoffeePicture()).thenThrow(
              exception,
            );
            expect(
              () async => coffeePicturesRepository.fetchCoffeePicture(),
              throwsA(exception),
            );
          });
        },
      );
    },
  );
}
