// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

class FakeCoffeePicture extends Fake implements CoffeePicture {}

void main() {
  late CoffeePicture coffeePicture;

  group('CoffeePictureBloc', () {
    late CoffeePicturesRepository coffeePicturesRepository;
    const file = 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg';

    setUpAll(() {
      registerFallbackValue(FakeCoffeePicture());
    });

    setUp(() {
      coffeePicturesRepository = MockCoffeePicturesRepository();
      coffeePicture = MockCoffeePicture();
      when(() => coffeePicture.file).thenReturn(file);
      when(() => coffeePicturesRepository.fetchCoffeePicture())
          .thenAnswer((_) async => coffeePicture);
    });

    CoffeePictureBloc buildBloc() {
      return CoffeePictureBloc(
        coffeePicturesRepository: coffeePicturesRepository,
      );
    }

    group('constructor', () {
      test('works properly', () => expect(buildBloc, returnsNormally));

      test('has correct initial state', () {
        expect(
          buildBloc().state,
          equals(const CoffeePictureState()),
        );
      });
    });

    group('CoffeePictureSubscriptionRequested', () {
      blocTest<CoffeePictureBloc, CoffeePictureState>(
        'fetches a coffee picture',
        build: buildBloc,
        act: (bloc) => bloc.add(const CoffeePictureSubscriptionRequested()),
        verify: (_) {
          verify(() => coffeePicturesRepository.fetchCoffeePicture()).called(1);
        },
      );

      blocTest<CoffeePictureBloc, CoffeePictureState>(
        'emits state with failure status '
        'when repository getTodos stream emits error',
        setUp: () {
          when(() => coffeePicturesRepository.fetchCoffeePicture())
              .thenAnswer((_) => Future.error(Exception('oops')));
        },
        build: buildBloc,
        act: (bloc) => bloc.add(const CoffeePictureSubscriptionRequested()),
        expect: () => [
          const CoffeePictureState(status: CoffeePictureStatus.loading),
          const CoffeePictureState(status: CoffeePictureStatus.failure),
        ],
      );
    });

    // group('CoffeePictureDownloadRequested', () {
    //   blocTest<CoffeePictureBloc, CoffeePictureState>(
    //     'throws AsertionError when coffee picture is null',
    //     build: buildBloc,
    //     act: (bloc) => bloc.add(CoffeePictureDownloadRequested(coffeePicture)),
    //     expect: () {
    //       expect(coffeePicture, throwsA(isA<AssertionError>()));
    //     },
    //   );
    // });
  });
}
