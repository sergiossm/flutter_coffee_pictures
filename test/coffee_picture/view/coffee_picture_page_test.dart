import 'package:bloc_test/bloc_test.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:flutter_coffee_pictures/coffee_picture/bloc/coffee_picture_bloc.dart';
import 'package:flutter_coffee_pictures/coffee_picture/view/view.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

// ignore: lines_longer_than_80_chars
class MockCoffeePicturesRepository extends Mock
    implements CoffeePicturesRepository {}

class MockCoffeePicture extends Mock implements CoffeePicture {}

// ignore: lines_longer_than_80_chars
class MockCoffeePictureBloc
    extends MockBloc<CoffeePictureEvent, CoffeePictureState>
    implements CoffeePictureBloc {}

void main() {
  late CoffeePicture coffeePicture;
  late CoffeePicturesRepository coffeePicturesRepository;
  const file = 'https://coffee.alexflipnote.dev/BYf2UB0AGTM_coffee.jpg';

  setUp(() {
    coffeePicturesRepository = MockCoffeePicturesRepository();
    coffeePicture = MockCoffeePicture();
    when(() => coffeePicture.file).thenReturn(file);
    when(() => coffeePicturesRepository.fetchCoffeePicture()).thenAnswer(
      (_) async => coffeePicture,
    );
  });

  group('CoffeePicturePage', () {
    testWidgets('renders CoffeePictureView', (tester) async {
      await tester.pumpApp(
        const CoffeePicturePage(),
        coffeePicturesRepository: coffeePicturesRepository,
      );

      expect(find.byType(CoffeePictureView), findsOneWidget);
    });

    // testWidgets('renders CoffeePictureView', (widgetTester) async {
    //   await widgetTester.pumpWidget(
    //     RepositoryProvider.value(
    //       value: coffeePicturesRepository,
    //       child: const CoffeePicturePage(),
    //     ),
    //   );
    //   expect(find.byType(CoffeePictureView), findsOneWidget);
    // });
  });

  group('CoffeePictureView', () {
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

    // testWidgets(
    //   'renders error Snackbar when status changes to failure',
    //   (widgetTester) async {
    //     whenListen<CoffeePictureState>(
    //       coffeePictureBloc,
    //       Stream.fromIterable([
    //         const CoffeePictureState(),
    //         const CoffeePictureState(
    //           status: CoffeePictureStatus.failure,
    //         ),
    //       ]),
    //     );

    //     await widgetTester.pumpApp(
    //       const CoffeePicturePage(),
    //       coffeePicturesRepository: coffeePicturesRepository,
    //     );
    //     await widgetTester.pumpAndSettle();

    //     // expect(find.byType(SnackBar), findsOneWidget);
    //     // expect(
    //     //   find.descendant(
    //     //     of: find.byType(SnackBar),
    //     //     matching: find.text(l10n.coffeePictureErrorSnackbarText),
    //     //   ),
    //     //   findsOneWidget,
    //     // );
    //   },
    // );

    // group('when coffee picture is not null', () {
    //   setUp(() {
    //     when(() => coffeePictureBloc.state).thenReturn(
    //       CoffeePictureState(
    //         status: CoffeePictureStatus.success,
    //         coffeePicture: coffeePicture,
    //       ),
    //     );
    //   });

    //   testWidgets('renders URL', (widgetTester) async {
    //     await widgetTester.pumpApp(
    //       const CoffeePicturePage(),
    //       coffeePicturesRepository: coffeePicturesRepository,
    //     );

    //     expect(find.byType(Center), findsOneWidget);
    //   });
    // });
  });
}
