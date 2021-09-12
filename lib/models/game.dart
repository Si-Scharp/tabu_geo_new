import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';

class Game {
  List<GeoCard> totalCards;
  final GameSettings gameSettings;
  final List<CardGuessingResult> results = List.empty(growable: true);

  List<GeoCard> getRemainingCards() => totalCards.toList()..removeWhere((element) => results.map((e) => e.card).contains(element));

  getCurrentTeamNumber() => results.length % gameSettings.numberOfTeams + 1;

  Game({required this.gameSettings, required this.totalCards});

  int getTeamScore(int teamNumber) {
    return results.where((element) => element.teamNumber == teamNumber && element.success == true).length;
  }


  SingleTeamStatistic getSingleTeamStatistic(int teamNumber) {
    var guessed = results.where((element) => element.teamNumber == teamNumber && element.success == true).length;
    var failed = results.where((element) => element.teamNumber == teamNumber && element.success == false).length;

    return SingleTeamStatistic(guessedCards: guessed, failedCards: failed);
  }

  List<SingleTeamStatistic> getAllTeamsStatistics() {
    return List.generate(gameSettings.numberOfTeams, (index) => getSingleTeamStatistic(index + 1));
  }

  int getTeamTotal(int teamNumber) {
    return results.where((element) => element.teamNumber == teamNumber).length;
  }

  void storeResult(CardGuessingResult cardGuessingResult) {
    totalCards.remove(cardGuessingResult.card);
    results.add(cardGuessingResult);
  }
}

class SingleTeamStatistic {
  final int guessedCards;
  final int failedCards;
  int get totalCards => guessedCards + failedCards;

  SingleTeamStatistic({required this.guessedCards, required this.failedCards});


}

class CardGuessingResult {
  GeoCard card;
  int teamNumber;
  bool success;

  CardGuessingResult({required this.card, this.teamNumber = 1, this.success = true});
}