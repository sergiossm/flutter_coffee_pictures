// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/view/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:network_image_mock/network_image_mock.dart';

import '../../helpers/helpers.dart';

class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

class MockCoffeePictureBloc
    extends MockBloc<CoffeePictureEvent, CoffeePictureState>
    implements CoffeePictureBloc {}

void main() {
  late CoffeePicturesRepository coffeePicturesRepository;
  final coffeePicture = CoffeePicture(
    file: 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg',
  );

  setUp(() {
    coffeePicturesRepository = MockCoffeePicturesRepository();
    when(() => coffeePicturesRepository.fetchCoffeePicture())
        .thenAnswer((_) async => coffeePicture);
  });

  group('CoffeePicturePage', () {
    testWidgets('renders CoffeePictureView', (tester) async {
      await mockNetworkImagesFor(
        () => tester.pumpApp(
          const CoffeePicturePage(),
          coffeePicturesRepository: coffeePicturesRepository,
        ),
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
        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );

        expect(find.byKey(refreshFloatingActionButtonKey), findsOneWidget);

        final refreshFloatingActionButton =
            widgetTester.widget(find.byKey(refreshFloatingActionButtonKey));
        expect(refreshFloatingActionButton, isA<FloatingActionButton>());
      });

      testWidgets(
          'calls CoffeePictureRefreshRequested '
          'when is clicked', (widgetTester) async {
        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );

        await widgetTester.tap(find.byKey(refreshFloatingActionButtonKey));

        verify(
          () => coffeePictureBloc.add(const CoffeePictureRefreshRequested()),
        ).called(1);
      });
    });

    group('download coffee picture button', () {
      testWidgets(
          'is rendered '
          'when downloadStatus is initial', (widgetTester) async {
        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );

        expect(find.byKey(downloadOutlinedButtonKey), findsOneWidget);

        final downloadOutlinedButton =
            widgetTester.widget(find.byKey(downloadOutlinedButtonKey));
        expect(downloadOutlinedButton, isA<OutlinedButton>());
      });

      testWidgets(
          'calls CoffeePictureDownloadRequested '
          'when is clicked', (widgetTester) async {
        when(() => coffeePictureBloc.state).thenReturn(
          CoffeePictureState(
            status: CoffeePictureStatus.success,
            coffeePicture: coffeePicture,
          ),
        );

        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );

        await mockNetworkImagesFor(
          () => widgetTester.tap(find.byKey(downloadOutlinedButtonKey)),
        );

        verify(
          () => coffeePictureBloc
              .add(CoffeePictureDownloadRequested(coffeePicture)),
        ).called(1);
      });
    });

    group('renders snackbar', () {
      testWidgets('when status changes to failure', (widgetTester) async {
        whenListen<CoffeePictureState>(
          coffeePictureBloc,
          Stream.fromIterable([
            CoffeePictureState(
              coffeePicture: coffeePicture,
            ),
            CoffeePictureState(
              coffeePicture: coffeePicture,
              status: CoffeePictureStatus.failure,
            ),
          ]),
        );

        await widgetTester.pumpApp(
          buildSubject(),
          coffeePicturesRepository: coffeePicturesRepository,
        );

        await widgetTester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('when download status changes to failure',
          (widgetTester) async {
        whenListen<CoffeePictureState>(
          coffeePictureBloc,
          Stream.fromIterable([
            CoffeePictureState(
              coffeePicture: coffeePicture,
              status: CoffeePictureStatus.success,
              downloadStatus: CoffeePictureDownloadStatus.downloading,
            ),
            CoffeePictureState(
              coffeePicture: coffeePicture,
              status: CoffeePictureStatus.success,
              downloadStatus: CoffeePictureDownloadStatus.failure,
            ),
          ]),
        );

        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );
        await mockNetworkImagesFor(() => widgetTester.pumpAndSettle());

        expect(find.byType(SnackBar), findsOneWidget);
      });

      testWidgets('when download status changes to success',
          (widgetTester) async {
        whenListen<CoffeePictureState>(
          coffeePictureBloc,
          Stream.fromIterable([
            CoffeePictureState(
              coffeePicture: coffeePicture,
              status: CoffeePictureStatus.success,
              downloadStatus: CoffeePictureDownloadStatus.downloading,
            ),
            CoffeePictureState(
              coffeePicture: coffeePicture,
              status: CoffeePictureStatus.success,
              downloadStatus: CoffeePictureDownloadStatus.success,
            ),
          ]),
        );

        await mockNetworkImagesFor(
          () => widgetTester.pumpApp(
            buildSubject(),
            coffeePicturesRepository: coffeePicturesRepository,
          ),
        );
        await mockNetworkImagesFor(() => widgetTester.pumpAndSettle());

        expect(find.byType(SnackBar), findsOneWidget);
      });
    });
  });
}
