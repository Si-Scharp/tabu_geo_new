part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class GameStartedEvent extends GameEvent {}

class GuessingResultSubmittedEvent extends GameEvent {
  GuessingResultSubmittedEvent([bool success = true]);
}

class CardRevealedEvent extends GameEvent {

}

class GuessingResultConfirmedEvent extends GameEvent {

}

//Replaced by the CardDroppedEvent
class CardDroppedEvent extends GameEvent {
  ///True if the player guessed it correct
  final bool correct;
  CardDroppedEvent({this.correct = true});

}



class TimeTickEvent extends GameEvent {}
