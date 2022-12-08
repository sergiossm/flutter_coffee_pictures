// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/view/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class MockCoffeePicturesRepository extends Mock implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

class MockCoffeePictureBloc extends MockBloc<CoffeePictureEvent, CoffeePictureState> implements CoffeePictureBloc {}

void main() {
  late CoffeePicturesRepository coffeePicturesRepository;
  final coffeePicture = CoffeePicture(file: 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg');

  setUp(() {
    coffeePicturesRepository = MockCoffeePicturesRepository();
    when(() => coffeePicturesRepository.fetchCoffeePicture()).thenAnswer((_) async => coffeePicture);
  });

  group('CoffeePicturePage', () {
    testWidgets('renders CoffeePictureView', (tester) async {
      await tester.pumpApp(
        const CoffeePicturePage(),
        coffeePicturesRepository: coffeePicturesRepository,
      );

      expect(find.byType(CoffeePictureView), findsOneWidget);
    });
  });

  group('CoffeePictureView', () {
    const refreshFloatingActionButtonKey = Key(
      'coffeePictureView_refresh_floatingActionButton',
    );
    const downloadOutlinedButtonKey = Key(
      'coffeePictureView_download_outlinedButton',
    );
    const emptySizedBoxKey = Key(
      'coffeePictureView_empty_sizedBox',
    );

    late CoffeePictureBloc coffeePictureBloc;

    setUp(() {
      coffeePictureBloc = MockCoffeePictureBloc();
      when(() => coffeePictureBloc.state).thenReturn(
        CoffeePictureState(
          status: CoffeePictureStatus.success,
          coffeePicture: coffeePicture,
        ),
      );
    });

    Widget buildSubject() {
      return BlocProvider.value(
        value: coffeePictureBloc,
        child: const CoffeePictureView(),
      );
    }

    group('refresh floating action button ', () {
      testWidgets('is rendered', (widgetTester) async {
        await widgetTester.pumpApp(
          buildSubject(),
          coffeePicturesRepository: coffeePicturesRepository,
        );

        expect(find.byKey(refreshFloatingActionButtonKey), findsOneWidget);

        final refreshFloatingActionButton = widgetTester.widget(find.byKey(refreshFloatingActionButtonKey));
        expect(refreshFloatingActionButton, isA<FloatingActionButton>());
      });

      testWidgets(
          'calls CoffeePictureRefreshRequested '
          'when is clicked', (widgetTester) async {
        await widgetTester.pumpApp(
          buildSubject(),
          coffeePicturesRepository: coffeePicturesRepository,
        );

        await widgetTester.tap(find.byKey(refreshFloatingActionButtonKey));

        verify(() => coffeePictureBloc.add(const CoffeePictureRefreshRequested())).called(1);
      });
    });

    group('download coffee picture button', () {
      testWidgets(
          'is rendered '
          'when downloadStatus is initial', (widgetTester) async {
        await widgetTester.pumpApp(
          buildSubject(),
          coffeePicturesRepository: coffeePicturesRepository,
        );

        expect(find.byKey(downloadOutlinedButtonKey), findsOneWidget);

        final downloadOutlinedButton = widgetTester.widget(find.byKey(downloadOutlinedButtonKey));
        expect(downloadOutlinedButton, isA<OutlinedButton>());
      });

      testWidgets(
        'is not rendered '
        'when downloadedStatus is success',
        (widgetTester) async {
          when(() => coffeePictureBloc.state).thenReturn(
            CoffeePictureState(
              status: CoffeePictureStatus.success,
              coffeePicture: coffeePicture,
              downloadStatus: CoffeePictureDownloadStatus.success,
            ),
          );

          await widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          );

          expect(find.byKey(emptySizedBoxKey), findsOneWidget);

          final emptySizedBox = widgetTester.widget(find.byKey(emptySizedBoxKey));
          expect(emptySizedBox, isA<SizedBox>());
        },
      );

      testWidgets(
          'calls CoffeePictureDownloadRequested '
          'when is clicked', (widgetTester) async {
        await widgetTester.pumpApp(
          buildSubject(),
          coffeePicturesRepository: coffeePicturesRepository,
        );

        await widgetTester.tap(find.byKey(downloadOutlinedButtonKey));

        verify(() => coffeePictureBloc.add(CoffeePictureDownloadRequested(coffeePicture))).called(1);
      });
    });
  });
}
