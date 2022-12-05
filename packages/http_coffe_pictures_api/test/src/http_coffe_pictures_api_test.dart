// ignore_for_file: prefer_const_constructors

import 'package:coffee_pictures_api/coffee_pictures_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http_coffe_pictures_api/http_coffe_pictures_api.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements http.Client {}

class MockResponse extends Mock implements http.Response {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('HttpCoffePicturesApi', () {
    late http.Client httpClient;
    late HttpCoffePicturesApi httpCoffePicturesApi;

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    setUp(() {
      httpClient = MockHttpClient();
      httpCoffePicturesApi = HttpCoffePicturesApi(httpClient: httpClient);
    });

    group('constructor', () {
      test('does not require an httpClient', () {
        expect(HttpCoffePicturesApi(), isNotNull);
      });
    });

    group('fetchCoffeePicture', () {
      test('makes correct http request', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        try {
          await httpCoffePicturesApi.fetchCoffeePicture();
        } catch (_) {}
        verify(
          () => httpClient.get(
            Uri.https('coffee.alexflipnote.dev', 'random.json'),
          ),
        ).called(1);
      });

      test('throws CoffeePicturesRequestFailure on non-200 response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(400);
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => httpCoffePicturesApi.fetchCoffeePicture(),
          throwsA(isA<CoffeePicturesRequestFailure>()),
        );
      });

      test('throws WeatherNotFoundFailure on empty response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn('{}');
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        expect(
          () async => httpCoffePicturesApi.fetchCoffeePicture(),
          throwsA(isA<CoffeePictureFileNotFoundFailure>()),
        );
      });

      test('returns coffee picture on valid response', () async {
        final response = MockResponse();
        when(() => response.statusCode).thenReturn(200);
        when(() => response.body).thenReturn(
          '''
{
"file": "https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg"
}
        ''',
        );
        when(() => httpClient.get(any())).thenAnswer((_) async => response);
        final actual = await httpCoffePicturesApi.fetchCoffeePicture();
        expect(
          actual,
          isA<CoffeePicture>().having(
            (cf) => cf.file,
            'file',
            'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg',
          ),
        );
      });
    });
  });
}
