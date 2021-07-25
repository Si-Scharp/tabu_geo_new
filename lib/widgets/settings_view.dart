import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text("Uhranzeige"),
          subtitle:
              Text("Zeige hier eine Beschreibung der ausgewählten Aktion"),
          trailing: DropdownButton<TimeType>(
            value: TimeType.none,
            items: [
              DropdownMenuItem(child: Text("Keine"), value: TimeType.none,),
              DropdownMenuItem(child: Text("Stoppuhr"), value: TimeType.stopwatch,),
              DropdownMenuItem(child: Text("Timer"), value: TimeType.timer,),
            ],
          ),
        ),
        ListTile(title: Text("Zeitlimit"), trailing: SizedBox(width: 50,child: Slider(min: 10, max: 300, onChanged: (double value) {  }, value: 30,)),),
        /*ListTile(
          title: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Text("Zeitlimit"),
            SizedBox(
              width: 4,
            ),
            Checkbox(
              value: true,
              onChanged: (value) {},
            )
          ]),
          trailing: SizedBox(
            width: 40,
            child: TextField(
              decoration:
                  InputDecoration(suffix: Text("s"), helperText: "10-300"),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          leading: Icon(Icons.timer),
          subtitle: Row(
            children: [
              Flexible(
                child: Text(
                    "Nach Ablauf wird ein Hinweis angezeigt und ein Ton abgespielt"),
              ),
              SizedBox(
                width: 3,
              ),
              IconButton(
                  onPressed: () => {}, icon: Icon(Icons.play_arrow_outlined))
            ],
          ),
        ),*/ // Old Time Limit
        ListTile(
          title: Text("Maximal Anzahl an Karten pro Spiel"),
          trailing: SizedBox(width: 50,child: Slider(onChanged: (double value) {  }, value: 20, min: 5, max: 50, label: "zeige hier wert oder max an",)),
        )
        // Time Limit Settings
      ],
    );
  }
}
