// ignore_for_file: lines_longer_than_80_chars

part of 'coffee_picture_bloc.dart';

enum CoffeePictureStatus { initial, loading, success, failure }

enum CoffeePictureDownloadStatus { initial, downloading, success, failure }

class CoffeePictureState extends Equatable {
  const CoffeePictureState({
    this.status = CoffeePictureStatus.initial,
    this.downloadStatus = CoffeePictureDownloadStatus.initial,
    this.coffeePicture,
  });

  final CoffeePictureStatus status;
  final CoffeePictureDownloadStatus downloadStatus;
  final CoffeePicture? coffeePicture;

  CoffeePictureState copyWith({
    CoffeePictureStatus Function()? status,
    CoffeePictureDownloadStatus Function()? downloadStatus,
    double Function()? downloadProgress,
    CoffeePicture Function()? coffeePicture,
  }) {
    return CoffeePictureState(
      status: status != null ? status() : this.status,
      downloadStatus: downloadStatus != null ? downloadStatus() : this.downloadStatus,
      coffeePicture: coffeePicture != null ? coffeePicture() : this.coffeePicture,
    );
  }

  @override
  List<Object?> get props => [
        status,
        downloadStatus,
        coffeePicture,
      ];
}
