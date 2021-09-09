import 'dart:async';
import 'package:flutter/scheduler.dart';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tabu_geo_new/bloc/game_bloc/game_bloc.dart';
import 'package:tabu_geo_new/models/game.dart';
import 'package:tabu_geo_new/models/game_settings.dart';
import 'package:tabu_geo_new/models/geo_card.dart';
import 'package:tabu_geo_new/widgets/card_view_widget.dart';
import 'package:tabu_geo_new/widgets/drag_fade.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key, required this.cards, required this.gameSettings}) : super(key: key);

  final List<GeoCard> cards;

  final GameSettings gameSettings;

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> with SingleTickerProviderStateMixin {
  late final AnimationController _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600), value: 1);
  late final Animation<double> _animation = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);

  late final FlipCardController _flipCardController;

  late bool _isFront = true;

  @override
  void initState() {
    _flipCardController = FlipCardController();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GameBloc(gameSettings: widget.gameSettings, initialCards: widget.cards, game: Game(cards: widget.cards, gameSettings: widget.gameSettings)),
      child: BlocConsumer<GameBloc, GameState>(
        listener: (context, state) {
          print("High");
          if (state is GameCardHiddenState) _controller.forward(from: 0);
          if (state is GameCardShownState) {
            SchedulerBinding.instance!.addPostFrameCallback((timeStamp) {
              if (_flipCardController.state != null && _flipCardController.state!.isFront)
                _flipCardController.toggleCard();
              _isFront = false;
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: EdgeInsets.all(30),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 380, maxHeight: 500, minHeight: 100, minWidth: 200),
                  child: SizedBox.expand(
                    child: ScaleTransition(
                      scale: _controller,
                      child: (state is GameCardShownState)
                          ? _shownCard(context, state)
                          : (state is GameCardHiddenState)
                              ? _hiddenCard(context)
                              : _noCard(context, state as GameNotStartedState),
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

  Widget _shownCard(BuildContext context, GameCardShownState state) {
    return FlipCard(
      flipOnTouch: false,
      controller: _flipCardController,
      back: DragFade(
        onDrop: (result) => context.read<GameBloc>().add(CardDroppedEvent(correct: result)),
          child: Container(
              color: Colors.grey.shade300,
              child: Padding(padding: EdgeInsets.all(20), child: CardViewWidget(state.card)))),
      front: _hiddenCard(context),
    );
  }

  Widget _hiddenCard(BuildContext context) {
    return GestureDetector(
        onTap: () => context.read<GameBloc>().add(CardRevealedEvent()),
        child: SizedBox.expand(child: Container(color: Colors.lightBlueAccent)));
  }

  Widget _noCard(BuildContext context, GameNotStartedState state) {
    return GestureDetector(
      child: Container(
        color: Colors.lightBlueAccent,
        child: Center(
          child: Icon(Icons.play_arrow),
        ),
      ),
      onTap: () {
        context.read<GameBloc>().add(GameStartedEvent());
      },
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
