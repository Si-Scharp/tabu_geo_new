import 'dart:async';
import 'dart:math';
import "package:uuid/uuid.dart";
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tabu_geo_new/models/game.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';
import 'package:tabu_geo_new/widgets/card_buttons.dart';

part 'game_event.dart';

part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  late Game game;

  GeoCard getCurrentCard() => game.totalCards[game.results.length];

  GameBloc({required this.game})
      : super(GameNotStartedState(
            gameSettings: game.gameSettings,
            teamStatistics: game.getAllTeamsStatistics(),
            totalCards: game.totalCards.length)) {
    game.totalCards.shuffle();
    game.totalCards = game.totalCards.take(game.gameSettings.numberOfCards).toList();
  }


// @formatter:off
  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    print(game.getCurrentTeamNumber());
    if (event is GameStartedEvent && state is GameNotStartedState) yield _nextCard();
    else if (event is GameStartedEvent && !(state is GameNotStartedState)) throw ArgumentError("Calling GameStartedEvent while the game is running is not allowed", "event");
    else if (event is CardRevealedEvent) yield _revealCard();
    else if (event is GuessingResultSubmittedEvent) yield _submitResult(event.success);
    else if (event is GuessingResultConfirmedEvent) yield _confirmResult();
    else if (event is UndoResultEvent) yield _undoResult();
    else throw UnsupportedError("The state type ${event.runtimeType} is not supported");
  }
// @formatter:on

  GameCardHiddenState _nextCard() {
    return GameCardHiddenState(
        gameSettings: game.gameSettings,
        totalCards: game.totalCards.length,
        teamStatistics: game.getAllTeamsStatistics());
  }

  GameCardShownState _revealCard() {
    return GameCardShownState(
        totalCards: game.totalCards.length,
        gameSettings: game.gameSettings,
        card: getCurrentCard(),
        teamStatistics: game.getAllTeamsStatistics());
  }

  bool? _submittedResult;

  GameCardShownState _submitResult(bool success) {

    _submittedResult = success;

    return GameCardShownState(
        totalCards: game.totalCards.length,
        gameSettings: game.gameSettings,
        card: getCurrentCard(),
        buttonState: success ? ButtonState.correct : ButtonState.wrong,
        teamStatistics: game.getAllTeamsStatistics());
  }

  GameCardShownState _undoResult() {
    _submittedResult = null;

    return GameCardShownState(
        totalCards: game.totalCards.length,
        gameSettings: game.gameSettings,
        card: getCurrentCard(),
        buttonState: ButtonState.unspecified,
        teamStatistics: game.getAllTeamsStatistics());
  }

  GameCardHiddenState _confirmResult() {
    if (_submittedResult == null) {
      throw StateError("A result must first be submitted before confirming it");
    }
    game.results.add(CardGuessingResult(card: getCurrentCard(), success: _submittedResult!, teamNumber: game.getCurrentTeamNumber()));
    return _nextCard();
  }
}
