

class GameSettings {
  bool showDescription = true;
  bool showImage = true;
  bool showForbiddenWords = true;
  int numberOfCards = 1;
  bool showScoringDuringPlay = true;

  ///1+, never 0
  int numberOfTeams = 1;
  Duration? timeLimitPerCard;
}

enum TimeType {
  none,
  stopwatch,
  timer
}