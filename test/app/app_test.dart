import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/app/app.dart';
import 'package:flutter_coffee_pictures/theme/theme.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/helpers.dart';

class MockCoffeePicture extends Mock implements CoffeePicture {}

void main() {
  late CoffeePicturesRepository coffeePicturesRepository;
  const file = 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg';

  setUp(() {
    coffeePicturesRepository = MockCoffeePicturesRepository();
    final coffeePicture = MockCoffeePicture();
    when(() => coffeePicture.file).thenReturn(file);
    when(() => coffeePicturesRepository.fetchCoffeePicture()).thenAnswer(
      (_) async => coffeePicture,
    );
  });

  group('App', () {
    testWidgets(
      'renders AppView',
      (widgetTester) async {
        await widgetTester.pumpWidget(
          App(coffeePicturesRepository: coffeePicturesRepository),
        );

        expect(find.byType(AppView), findsOneWidget);
      },
    );
  });

  group('AppView', () {
    testWidgets('renders MaterialApp', (widgetTester) async {
      await widgetTester.pumpWidget(
        RepositoryProvider.value(
          value: coffeePicturesRepository,
          child: const AppView(),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);

      final materialApp = widgetTester.widget<MaterialApp>(find.byType(
        MaterialApp,
      ));
      expect(materialApp.theme, equals(FlutterCoffeePicturesTheme.light));
      expect(materialApp.darkTheme, equals(FlutterCoffeePicturesTheme.dark));
    });

    testWidgets('renders CoffeePicturePage', (widgetTester) async {
      await widgetTester.pumpWidget(
        RepositoryProvider.value(
          value: coffeePicturesRepository,
          child: const AppView(),
        ),
      );
    });
  });
}
