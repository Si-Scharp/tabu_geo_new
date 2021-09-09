import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:tabu_geo_new/models/geo_card.dart';
import 'package:tabu_geo_new/widgets/card_view_widget.dart';

class ConcentricCardView extends StatefulWidget {
  @override
  _ConcentricCardViewState createState() => _ConcentricCardViewState();

  bool revealed;
  GeoCard? card;
  int teamNumber;

  ConcentricCardView({this.card, this.revealed = false, this.teamNumber = 1});
}

class _ConcentricCardViewState extends State<ConcentricCardView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late bool _revealed;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _controller.addListener(() {});
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.revealed == true && _controller.status == AnimationStatus.dismissed) _controller.forward();
    });

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) => Card(
        color: Colors.lightBlueAccent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Ein Spieler aus Team"),
                Text(widget.teamNumber.toString(), style: TextStyle(fontSize: 30)),
                Text("soll diesen Begriff vorstellen."),
                Text("Tippe zum enthüllen."),
              ],
            ),
            ClipPath(
                clipper: ConcentricClipper(progress: _controller.value),
                child: widget.revealed == true
                    ? widget.card != null
                        ? CardViewWidget(widget.card!)
                        : Text("Wenn du das liest ist ein unerwarteter Fehler aufgetreten.")
                    : Text("Diesen Text Sollte man nicht lesen können, denn die Karte ist versteckt")),
          ],
        ),
      ),
    );
  }
}
