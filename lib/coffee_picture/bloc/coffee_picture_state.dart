// ignore_for_file: lines_longer_than_80_chars

part of 'coffee_picture_bloc.dart';

enum CoffeePictureStatus { initial, loading, success, failure }

class CoffeePictureState extends Equatable {
  const CoffeePictureState({
    this.status = CoffeePictureStatus.initial,
    this.coffeePicture,
  });

  final CoffeePictureStatus status;
  final CoffeePicture? coffeePicture;

  CoffeePictureState copyWith({
    CoffeePictureStatus Function()? status,
    CoffeePicture Function()? coffeePicture,
  }) {
    return CoffeePictureState(
      status: status != null ? status() : this.status,
      coffeePicture: coffeePicture != null ? coffeePicture() : this.coffeePicture,
    );
  }

  @override
  List<Object?> get props => [
        status,
        coffeePicture,
      ];
}
