// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

void main() {
  group(
    'CoffeePictureState',
    () {
      late CoffeePicturesRepository coffeePicturesRepository;
      late CoffeePicture coffeePicture;
      const file = 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg';

      setUp(() {
        coffeePicturesRepository = MockCoffeePicturesRepository();
        coffeePicture = MockCoffeePicture();
        when(() => coffeePicture.file).thenReturn(file);
        when(() => coffeePicturesRepository.fetchCoffeePicture()).thenAnswer(
          (_) async => coffeePicture,
        );
      });

      CoffeePictureState createSubject({
        CoffeePictureStatus status = CoffeePictureStatus.initial,
      }) {
        return CoffeePictureState(status: status, coffeePicture: coffeePicture);
      }

      test('supports value equality', () {
        createSubject();
        equals(createSubject());
      });

      test('props are correct', () {
        expect(
          createSubject().props,
          equals(<Object?>[
            CoffeePictureStatus.initial,
            coffeePicture,
          ]),
        );
      });

      group(
        'copyWith',
        () {
          test('returns the same object if not arguments are provided', () {
            expect(
              createSubject().copyWith(),
              equals(createSubject()),
            );
          });

          test('retains the old value for every parameter if null is provided',
              () {
            expect(
              createSubject().copyWith(
                status: null,
                coffeePicture: null,
              ),
              equals(createSubject()),
            );
          });

          test('replaces every non-null parameter', () {
            expect(
              createSubject().copyWith(
                status: () => CoffeePictureStatus.success,
                coffeePicture: () => coffeePicture,
              ),
              equals(
                createSubject(
                  status: CoffeePictureStatus.success,
                ),
              ),
            );
          });
        },
      );
    },
  );
}
