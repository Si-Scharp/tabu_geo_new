import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';

class Game {
  final List<GeoCard> cards;
  final GameSettings gameSettings;
  final List<CardGuessingResult> results = List.empty();
  Game({required this.gameSettings, required this.cards});

  int getTeamScore(int teamNumber) {
    return results.where((element) => element.teamNumber == teamNumber && element.success == true).length;
  }

  int getTeamTotal(int teamNumber) {


    return results.where((element) => element.teamNumber == teamNumber).length;
  }

  void storeResult(CardGuessingResult cardGuessingResult) {
    cards.remove(cardGuessingResult.card);
    results.add(cardGuessingResult);
  }
}

class CardGuessingResult {
  GeoCard card;
  int teamNumber;
  bool success;

  CardGuessingResult({required this.card, this.teamNumber = 1, this.success = true});
}