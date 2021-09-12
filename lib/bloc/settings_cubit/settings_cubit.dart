import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:tabu_geo_new/bloc/card_cubit/card_loader_cubit.dart';
import 'package:tabu_geo_new/bloc/game_bloc/game_bloc.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:uuid/uuid.dart';
part 'settings_state.dart';



class SettingsCubit extends Cubit<SettingsState> {
  late final GameSettings _gameSettings;
  late final CardLoaderCubit _cardLoaderCubit;
  bool cardsMultipleTeamNumber = false;

  bool _initialCardsLoadedSettingsSet = false;

  void updateGameSettings(void update(GameSettings settings)) {
    update.call(_gameSettings);
    _emit();
  }

  void _adjustCardNumbersToTeamNumbers() {
    if (cardsMultipleTeamNumber == true) {
      int ceil = (_gameSettings.numberOfCards/_gameSettings.numberOfTeams).ceil() * _gameSettings.numberOfTeams;
      int floor = (_gameSettings.numberOfCards/_gameSettings.numberOfTeams).floor() * _gameSettings.numberOfTeams;
      int round = (_gameSettings.numberOfCards/_gameSettings.numberOfTeams).round() * _gameSettings.numberOfTeams;



      if (ceil > (_cardLoaderCubit.state as CardsLoadedState).cards.length)
        _gameSettings.numberOfCards = floor;
      else _gameSettings.numberOfCards = ceil;
    }
  }

  void toogleCMTN() {
    cardsMultipleTeamNumber = !cardsMultipleTeamNumber;


    _emit();
  }

  void _emit() {

    _adjustCardNumbersToTeamNumbers();
    emit(SettingsState(
        settings: _gameSettings,
        cardsMultipleTeamNumber: cardsMultipleTeamNumber,
        numberOfCards: (_cardLoaderCubit.state is CardsLoadedState)
            ? (_cardLoaderCubit.state as CardsLoadedState).cards.length
            : null));
  }

  void _setInitialSettings() {
    if (_cardLoaderCubit.state is! CardsLoadedState)
      throw UnsupportedError("The initial state can't be set until the Cards have been loaded");
    if (_initialCardsLoadedSettingsSet) return;

    _gameSettings.numberOfCards = (_cardLoaderCubit.state as CardsLoadedState).cards.length;
    _initialCardsLoadedSettingsSet = true;
  }

  SettingsCubit(GameSettings gameSettings, CardLoaderCubit cardLoaderCubit)
      : super(SettingsState(settings: gameSettings, cardsMultipleTeamNumber: false)) {

    _cardLoaderCubit = cardLoaderCubit;
    _cardLoaderCubit.stream.listen((event) {
      if (_cardLoaderCubit.state is CardsLoadedState) _setInitialSettings();
      _emit();
    });

    _gameSettings = gameSettings;


    if (_cardLoaderCubit.state is CardsLoadedState) _setInitialSettings();
  }
}
