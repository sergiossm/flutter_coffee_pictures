// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_coffee_pictures/app/app.dart';
import 'package:flutter_coffee_pictures/app/app_bloc_observer.dart';

void bootstrap({required CoffeePicturesApi coffeePicturesApi}) {
  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  Bloc.observer = AppBlocObserver();

  final coffeePicturesRepository = CoffeePicturesRepository(coffeePicturesApi: coffeePicturesApi);

  runZonedGuarded(
    () => runApp(App(coffeePicturesRepository: coffeePicturesRepository)),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
