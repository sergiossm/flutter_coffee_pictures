// ignore_for_file: lines_longer_than_80_chars, avoid_redundant_argument_values

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

class FakeCoffeePicture extends Fake implements CoffeePicture {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final mockCoffeePicture = CoffeePicture(
    file: 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg',
  );

  group('CoffeePictureBloc', () {
    late CoffeePicturesRepository coffeePicturesRepository;

    setUpAll(() {
      registerFallbackValue(FakeCoffeePicture());
    });

    setUp(() {
      coffeePicturesRepository = MockCoffeePicturesRepository();
      when(() => coffeePicturesRepository.fetchCoffeePicture())
          .thenAnswer((_) => Future.value(mockCoffeePicture));
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

    group('CoffeePictureRefreshRequested', () {
      blocTest<CoffeePictureBloc, CoffeePictureState>(
        'fetches a coffee picture',
        build: buildBloc,
        act: (bloc) => bloc.add(const CoffeePictureRefreshRequested()),
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
        act: (bloc) => bloc.add(const CoffeePictureRefreshRequested()),
        expect: () => [
          const CoffeePictureState(status: CoffeePictureStatus.loading),
          const CoffeePictureState(status: CoffeePictureStatus.failure),
        ],
      );
    });

    group('CoffeePictureDownloadRequested', () {
      blocTest<CoffeePictureBloc, CoffeePictureState>(
        'emits nothing when coffee picture is null',
        build: buildBloc,
        act: (bloc) =>
            bloc.add(CoffeePictureDownloadRequested(mockCoffeePicture)),
        expect: () => <CoffeePictureState>[],
      );

      blocTest<CoffeePictureBloc, CoffeePictureState>(
        'emits [downloading, failure] when downloadCoffeePicture returns an empty image',
        setUp: () {
          when(
            () => coffeePicturesRepository.downloadCoffeePicture(
              url: mockCoffeePicture.file,
            ),
          ).thenAnswer((_) async => []);
        },
        seed: () => CoffeePictureState(coffeePicture: mockCoffeePicture),
        build: buildBloc,
        act: (bloc) =>
            bloc.add(CoffeePictureDownloadRequested(mockCoffeePicture)),
        expect: () => <CoffeePictureState>[
          CoffeePictureState(
            downloadStatus: CoffeePictureDownloadStatus.downloading,
            coffeePicture: mockCoffeePicture,
          ),
          CoffeePictureState(
            downloadStatus: CoffeePictureDownloadStatus.failure,
            coffeePicture: mockCoffeePicture,
          ),
        ],
      );
    });
  });
}
