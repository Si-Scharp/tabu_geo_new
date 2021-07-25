part of 'game_bloc.dart';

@immutable
abstract class GameState {

}

class GameNotStartedState extends GameState {}

abstract class GameRunningState extends GameState {
  final int numberOfCurrentCard;
  final int totalCards;
  final GameSettings gameSettings;

  GameRunningState(
      this.numberOfCurrentCard, this.totalCards, this.gameSettings);
}

class GameCardHiddenState extends GameRunningState {

  GameCardHiddenState(
      int numberOfCurrentCard, int totalCards, GameSettings gameSettings)
      : super(numberOfCurrentCard, totalCards, gameSettings);
}

class GameCardShownState extends GameRunningState {
  final GeoCard card;

  final Duration? remainingTime;

  GameCardShownState(
      int numberOfCurrentCard, int totalCards, GameSettings gameSettings, this.card, this.remainingTime)
      : super(numberOfCurrentCard, totalCards, gameSettings);


}
