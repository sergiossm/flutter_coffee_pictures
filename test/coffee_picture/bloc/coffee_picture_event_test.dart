import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

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
    },
  );
}
