part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class GameStartedEvent extends GameEvent {}

class CardTappedEvent extends GameEvent {}


class CardDroppedEvent extends GameEvent {
  ///True if the player guessed it correct
  final bool correct;
  CardDroppedEvent({this.correct = true});

}

class TimeTickEvent extends GameEvent {}
