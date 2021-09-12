

part of 'game_bloc.dart';

abstract class GameState {
}

class GameLoadingState extends GameState {

}

abstract class GameReadyState extends GameState {
  int get currentTeamNumber => teamStatistics.fold(0, (int ct, element) => ct + element.totalCards) % gameSettings.numberOfTeams + 1;


  final List<SingleTeamStatistic> teamStatistics;
  final int totalCards;
  final GameSettings gameSettings;

  int get numberOfRemainingCards => totalCards - teamStatistics.fold(0, (counter, element) => counter += element.totalCards);

  GameReadyState({required this.totalCards, required this.gameSettings, required this.teamStatistics});
}

class GameNotStartedState extends GameReadyState {

  GameNotStartedState({required List<SingleTeamStatistic> teamStatistics, required int totalCards, required GameSettings gameSettings})
      : super(totalCards: totalCards, teamStatistics: teamStatistics, gameSettings: gameSettings);
}

abstract class GameRunningState extends GameReadyState {
  int get numberOfCurrentCard => teamStatistics.map((e) => e.totalCards).reduce((value, element) => value + element);


  GameRunningState({required GameSettings gameSettings, required List<SingleTeamStatistic> teamStatistics, required int totalCards}) : super(teamStatistics: teamStatistics, gameSettings: gameSettings, totalCards: totalCards);
}

class GameCardHiddenState extends GameRunningState {
  GameCardHiddenState({required GameSettings gameSettings, required int totalCards,
    required List<SingleTeamStatistic> teamStatistics})
      : super(teamStatistics: teamStatistics, totalCards: totalCards, gameSettings: gameSettings);
}

class GameCardShownState extends GameRunningState {
  final GeoCard card;
  ButtonState buttonState;

  final Duration? time;

  GameCardShownState({required int totalCards, required GameSettings gameSettings, required this.card, this.time,
      this.buttonState = ButtonState.unspecified, required List<SingleTeamStatistic> teamStatistics})
      : super(totalCards: totalCards, gameSettings: gameSettings, teamStatistics: teamStatistics);
}
