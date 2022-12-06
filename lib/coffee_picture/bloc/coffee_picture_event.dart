part of 'coffee_picture_bloc.dart';

abstract class CoffeePictureEvent extends Equatable {
  const CoffeePictureEvent();

  @override
  List<Object> get props => [];
}

class CoffeePictureSubscriptionRequested extends CoffeePictureEvent {
  const CoffeePictureSubscriptionRequested();
}
