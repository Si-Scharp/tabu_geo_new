part of 'card_loader_cubit.dart';

abstract class CardLoaderState {}





class CardsNotLoadedState extends CardLoaderState {}

class CardsLoadingState extends CardsNotLoadedState {}

class CardsLoadingErrorState extends CardsNotLoadedState {
  String? errorMessage;

  CardsLoadingErrorState(this.errorMessage);
}

class CardsLoadedState extends CardLoaderState{
  List<GeoCard> cards;

  CardsLoadedState(this.cards);
}