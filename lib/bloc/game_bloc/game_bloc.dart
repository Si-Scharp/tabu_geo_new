import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameSettings gameSettings;
  final List<GeoCard> initialCards;
  late List<GeoCard> remainingCards;

  late GeoCard currentCard;

  late Stopwatch stopwatch;
  late Timer tickerTimer;

  GameBloc({required this.gameSettings, required this.initialCards}) : super(GameNotStartedState()) {
    initialCards.shuffle();
    remainingCards = initialCards.toList();
  }

  @override
  Stream<GameState> mapEventToState(GameEvent event) async* {
    if (event is GameStartedEvent) yield _processCard();
    if (event is CardTappedEvent && state is GameCardHiddenState) yield _flipCard();
    if (event is CardDroppedEvent) yield _dropCard(event.correct);
    if (event is TimeTickEvent) yield _processTick();
  }

  GameCardShownState _processTick() {
    return GameCardShownState(remainingCards.length + 1, initialCards.length, gameSettings, currentCard,
        gameSettings.timeLimitPerCard! - stopwatch.elapsed);
  }

  GameCardHiddenState _dropCard(bool success) {
    tickerTimer.cancel();
    stopwatch
      ..stop()
      ..reset();
    return _processCard();
  }

  GameCardHiddenState _processCard() {
    currentCard = remainingCards.removeLast();

    return GameCardHiddenState(remainingCards.length + 1, initialCards.length, gameSettings);
  }

  GameCardShownState _flipCard() {
    if (gameSettings.timeLimitPerCard != null) {
      tickerTimer = new Timer.periodic(Duration(milliseconds: 100), (timer) {
        add(TimeTickEvent());
      });
      stopwatch = Stopwatch()..start();
    }

    return GameCardShownState(remainingCards.length + 1, initialCards.length, gameSettings, currentCard,
        gameSettings.timeLimitPerCard);
  }
}
