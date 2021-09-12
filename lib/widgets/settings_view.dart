import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/src/provider.dart';
import 'package:tabu_geo_new/bloc/card_cubit/card_loader_cubit.dart';
import 'package:tabu_geo_new/bloc/settings_cubit/settings_cubit.dart';
import 'package:tabu_geo_new/models/game_settings.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  late TextEditingController _timeController;

  @override
  void initState() {
    _timeController = TextEditingController();
    super.initState();
  }

  SettingsCubit get cubit => context.read<SettingsCubit>();

  List<Widget> _generateSettings(BuildContext context, SettingsState state) {
    List<Widget> widgets = List.empty(growable: true);

    widgets.add(ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Anzahl der Teams: ${state.settings.numberOfTeams}"),
          Slider(
            value: state.settings.numberOfTeams.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            label: state.settings.numberOfTeams.toString(),
            onChanged: (value) {
              context
                .read<SettingsCubit>()
                .updateGameSettings((settings) => settings..numberOfTeams = value.toInt());
            },
          )
        ],
      ),
    ));

    if (state.numberOfCards != null) {
      var max = state.cardsMultipleTeamNumber
          ? (state.numberOfCards! ~/ state.settings.numberOfTeams).toDouble()
          : state.numberOfCards!.toDouble();

      widgets.add(ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Anzahl der Karten: ${state.settings.numberOfCards}"),
            Slider(
              value: state.cardsMultipleTeamNumber ? state.settings.numberOfCards / state.settings.numberOfTeams : state.settings.numberOfCards.toDouble(),
              min: 1,
              max: max,
              divisions: max.toInt() - 1,
              label: state.settings.numberOfCards.toString(),
              onChanged: (value) => context.read<SettingsCubit>().updateGameSettings((settings) => settings
                ..numberOfCards =
                    value.toInt() * (state.cardsMultipleTeamNumber ? state.settings.numberOfTeams : 1)),
            )
          ],
        ),
      ));

      widgets.add(CheckboxListTile(
        title: Text("Anzahl der Karten an Anzahl der Teams anpassen"),
        value: state.cardsMultipleTeamNumber,
        onChanged: (value) => context.read<SettingsCubit>().toogleCMTN(),
      ));
    } else {
      widgets.add(ListTile(
        title: Text("Anzahl der Karten"),
        subtitle: Text("Diese Einstellung ist erst verfügbar sobald die Karten geladen wurden."),
      ));
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SettingsCubit>(
      create: (context) => SettingsCubit(context.read<GameSettings>(), context.read<CardLoaderCubit>()),
      child: BlocBuilder<SettingsCubit, SettingsState>(

        builder: (context, state) {
          return Column(
            children: [
              ListTile(
                title: Column(
                  children: _generateSettings(context, state),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
