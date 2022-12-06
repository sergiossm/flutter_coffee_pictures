// ignore_for_file: lines_longer_than_80_chars

import 'package:bloc/bloc.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:equatable/equatable.dart';

part 'coffee_picture_event.dart';
part 'coffee_picture_state.dart';

class CoffeePictureBloc extends Bloc<CoffeePictureEvent, CoffeePictureState> {
  CoffeePictureBloc({required CoffeePicturesRepository coffeePicturesRepository})
      : _coffeePicturesRepository = coffeePicturesRepository,
        super(const CoffeePictureState()) {
    on<CoffeePictureSubscriptionRequested>(_onSubscriptionRequested);
  }

  final CoffeePicturesRepository _coffeePicturesRepository;

  Future<void> _onSubscriptionRequested(CoffeePictureSubscriptionRequested event, Emitter<CoffeePictureState> emit) async {
    emit(state.copyWith(status: () => CoffeePictureStatus.loading));

    try {
      final coffeePicture = await _coffeePicturesRepository.fetchCoffeePicture();
      emit(
        state.copyWith(
          status: () => CoffeePictureStatus.success,
          coffeePicture: () => coffeePicture,
        ),
      );
    } on Exception {
      emit(state.copyWith(status: () => CoffeePictureStatus.failure));
    }
  }
}
