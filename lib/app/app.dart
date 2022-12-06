import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/view/coffee_picture_page.dart';
import 'package:flutter_coffee_pictures/l10n/l10n.dart';
import 'package:flutter_coffee_pictures/theme/theme.dart';

class App extends StatelessWidget {
  const App({super.key, required this.coffeePicturesRepository});

  final CoffeePicturesRepository coffeePicturesRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: coffeePicturesRepository,
      child: const AppView(),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: FlutterCoffeePicturesTheme.light,
      darkTheme: FlutterCoffeePicturesTheme.dark,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const CoffeePicturePage(),
    );
  }
}
