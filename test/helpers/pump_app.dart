import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/l10n/l10n.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

extension PumpApp on WidgetTester {
  Future<void> pumpApp(
    Widget widget, {
    CoffeePicturesRepository? coffeePicturesRepository,
  }) {
    return pumpWidget(
      RepositoryProvider.value(
        value: coffeePicturesRepository ?? MockCoffeePicturesRepository(),
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: widget),
        ),
      ),
    );
  }

  Future<void> pumpRoute(
    Route<dynamic> route, {
    CoffeePicturesRepository? todosRepository,
  }) {
    return pumpApp(
      Navigator(onGenerateRoute: (_) => route),
      coffeePicturesRepository: todosRepository,
    );
  }
}
