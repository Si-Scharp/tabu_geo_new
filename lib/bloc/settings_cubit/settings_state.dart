part of 'settings_cubit.dart';

class SettingsState {
  final GameSettings settings;
  int? numberOfCards;
  bool cardsMultipleTeamNumber;
  SettingsState({required this.settings, required this.cardsMultipleTeamNumber, this.numberOfCards});

  //region Equals
  final String _id = Uuid().v4();
  @override
  bool operator ==(Object other) => (other is SettingsState) && other._id == _id;
  @override
  int get hashCode => _id.hashCode;
  //endregion
}

