part of 'coffee_picture_bloc.dart';

abstract class CoffeePictureEvent extends Equatable {
  const CoffeePictureEvent();

  @override
  List<Object> get props => [];
}

class CoffeePictureSubscriptionRequested extends CoffeePictureEvent {
  const CoffeePictureSubscriptionRequested();
}

class CoffeePictureDownloadRequested extends CoffeePictureEvent {
  const CoffeePictureDownloadRequested(this.coffeePicture);

  final CoffeePicture coffeePicture;

  @override
  List<Object> get props => [coffeePicture];
}

class CoffeePictureRefreshRequested extends CoffeePictureEvent {
  const CoffeePictureRefreshRequested();
}
