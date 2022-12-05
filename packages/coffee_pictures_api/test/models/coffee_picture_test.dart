// ignore_for_file: avoid_redundant_argument_values
import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:test/test.dart';

void main() {
  group(
    'Coffee picture',
    () {
      CoffeePicture createSubject({
        String? id = '1',
        String file = 'file',
        bool isDownloaded = true,
      }) {
        return CoffeePicture(id: id, file: file, isDownloaded: isDownloaded);
      }

      group('constructor', () {
        test('works correctly', () {
          expect(
            createSubject,
            returnsNormally,
          );
        });

        test('throws AssertionError when id is empty', () {
          expect(
            () => createSubject(id: ''),
            throwsA(isA<AssertionError>()),
          );
        });

        test('sets id if not provided', () {
          expect(
            createSubject(id: null).id,
            isNotEmpty,
          );
        });
      });

      test('supports value equality', () {
        expect(
          createSubject(),
          equals(createSubject()),
        );
      });

      test('props are correct', () {
        expect(
          createSubject().props,
          equals([
            '1', // id
            'file', // file
            true, // isDownloaded
          ]),
        );
      });

      group('copyWith', () {
        test('returns the same object if not arguments are provided', () {
          expect(
            createSubject().copyWith(),
            equals(createSubject()),
          );
        });

        test(
          'retains the old value for every parameter if null is provided',
          () {
            expect(
              createSubject().copyWith(
                id: null,
                file: null,
                isDownloaded: null,
              ),
              equals(createSubject()),
            );
          },
        );

        test('replaces every non-null parameter', () {
          expect(
            createSubject().copyWith(
              id: '2',
              file: 'new file',
              isDownloaded: false,
            ),
            equals(
              createSubject(
                id: '2',
                file: 'new file',
                isDownloaded: false,
              ),
            ),
          );
        });
        group('fromJson', () {
          test('works correctly', () {
            expect(
              CoffeePicture.fromJson(<String, dynamic>{
                'id': '1',
                'file': 'file',
                'isDownloaded': true,
              }),
              equals(createSubject()),
            );
          });
        });

        group('toJson', () {
          test('works correctly', () {
            expect(
              createSubject().toJson(),
              equals(<String, dynamic>{
                'id': '1',
                'file': 'file',
                'isDownloaded': true,
              }),
            );
          });
        });
      });
    },
  );
}
