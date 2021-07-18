import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_geo_new/bloc/game_bloc/game_bloc.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';
import 'package:tabu_geo_new/widgets/card_view_widget.dart';
import 'package:tabu_geo_new/widgets/drag_fade.dart';

class PlayPage extends StatelessWidget {
  const PlayPage({Key? key, required this.cards, required this.gameSettings}) : super(key: key);

  final List<GeoCard> cards;

  final GameSettings gameSettings;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(gameSettings: gameSettings, initialCards: cards),
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380, maxHeight: 500, minHeight: 100, minWidth: 200),
                  child: SizedBox.expand(
                    child: DragFade(
                      child: Card(
                        color: Colors.white30,
                        child: Padding(padding: EdgeInsets.all(20), child: CardViewWidget(tk)),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

GeoCard tk = GeoCard()
  ..image = (GeoImage()
    ..url =
        "https://upload.wikimedia.org/wikipedia/commons/thumb/f/f8/World_map_with_equator.jpg/690px-World_map_with_equator.jpg")
  ..forbiddenWords = ["Halbkugel", "Breitenkreis", "teilt"]
  ..term = "Äquator"
  ..definition =
      "Größter Breitenkreis auf der Erde, der die Erdkugel in die nördliche und südliche Halbkugel teilt";
