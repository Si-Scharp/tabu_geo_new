part of 'game_bloc.dart';

@immutable
abstract class GameEvent {}

class GameStartedEvent extends GameEvent {

}

class GuessingResultSubmittedEvent extends GameEvent {
  final bool success;

  GuessingResultSubmittedEvent([this.success = true]);
}

class CardRevealedEvent extends GameEvent {

}

class GuessingResultConfirmedEvent extends GameEvent {
}

class UndoResultEvent extends GameEvent {

}