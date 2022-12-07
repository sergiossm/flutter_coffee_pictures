import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeePicture extends Mock implements CoffeePicture {}

void main() {
  group(
    'CoffeePictureEvent',
    () {
      group('CoffeePictureSubscriptionRequested', () {
        test('supports value equality', () {
          expect(
            const CoffeePictureSubscriptionRequested(),
            equals(const CoffeePictureSubscriptionRequested()),
          );
        });

        test('props are correct', () {
          expect(
            const CoffeePictureSubscriptionRequested().props,
            equals(<Object?>[]),
          );
        });
      });

      group('CoffeePictureDownloadRequested', () {
        final mockCoffeePicture = MockCoffeePicture();

        test('supports value equality', () {
          expect(
            CoffeePictureDownloadRequested(mockCoffeePicture),
            equals(CoffeePictureDownloadRequested(mockCoffeePicture)),
          );
        });

        test('props are correct', () {
          expect(
            CoffeePictureDownloadRequested(mockCoffeePicture).props,
            equals(<Object?>[mockCoffeePicture]),
          );
        });
      });
    },
  );
}
