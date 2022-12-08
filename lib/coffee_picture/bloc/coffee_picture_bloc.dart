// ignore_for_file: lines_longer_than_80_chars

import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:coffee_pictures_repository/coffee_pictures_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

part 'coffee_picture_event.dart';
part 'coffee_picture_state.dart';

class CoffeePictureBloc extends Bloc<CoffeePictureEvent, CoffeePictureState> {
  CoffeePictureBloc({
    required CoffeePicturesRepository coffeePicturesRepository,
  })  : _coffeePicturesRepository = coffeePicturesRepository,
        super(const CoffeePictureState()) {
    on<CoffeePictureSubscriptionRequested>(_onSubscriptionRequested);
    on<CoffeePictureDownloadRequested>(_onCoffeePictureDownloadRequested);
    on<CoffeePictureRefreshRequested>(_onCoffeePictureRefreshRequested);
  }

  final CoffeePicturesRepository _coffeePicturesRepository;

  Future<void> _fetchCoffeePicture(Emitter<CoffeePictureState> emit) async {
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

  Future<void> _onSubscriptionRequested(
    CoffeePictureSubscriptionRequested _,
    Emitter<CoffeePictureState> emit,
  ) =>
      _fetchCoffeePicture(emit);

  Future<void> _onCoffeePictureRefreshRequested(
    CoffeePictureRefreshRequested event,
    Emitter<CoffeePictureState> emit,
  ) =>
      _fetchCoffeePicture(emit);

  Future<void> _onCoffeePictureDownloadRequested(
    CoffeePictureDownloadRequested event,
    Emitter<CoffeePictureState> emit,
  ) async {
    assert(
      state.coffeePicture != null && state.coffeePicture!.file.isNotEmpty,
      'Coffee picture can not be null or should not be empty',
    );

    emit(
      state.copyWith(
        downloadStatus: () => CoffeePictureDownloadStatus.downloading,
      ),
    );
    try {
      final bytes = await _coffeePicturesRepository.downloadCoffeePicture(
        url: state.coffeePicture!.file,
      );

      if (bytes.isEmpty) {
        emit(
          state.copyWith(downloadStatus: () => CoffeePictureDownloadStatus.failure),
        );
      } else {
        final result = await ImageGallerySaver.saveImage(Uint8List.fromList(bytes)) as Map?;
        emit(
          state.copyWith(
            downloadStatus: () => (result?.containsKey('isSuccess') ?? false) && (result?['isSuccess'] ?? false) == true
                ? CoffeePictureDownloadStatus.success
                : CoffeePictureDownloadStatus.failure,
          ),
        );
      }
    } on Exception {
      emit(state.copyWith(downloadStatus: () => CoffeePictureDownloadStatus.failure));
    }
  }
}
