import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:tabu_geo_new/models/geo_card.dart';
import 'package:tabu_geo_new/util/team_colors.dart';
import 'package:tabu_geo_new/widgets/card_view_widget.dart';
class ConcentricCardView extends StatefulWidget {
  @override
  _ConcentricCardViewState createState() => _ConcentricCardViewState();

  bool revealed;
  GeoCard? card;
  int teamNumber;



  /// Called when the revealing Animation has completed
  VoidCallback? onRevealed;

  /// Called when the card has been tapped
  ///
  /// When not set the card will automatically reveal
  VoidCallback? onTap;
  ConcentricCardView({this.card, this.revealed = false, this.teamNumber = 1, this.onRevealed, this.onTap});
}

class _ConcentricCardViewState extends State<ConcentricCardView> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late bool _revealed;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onRevealed?.call();
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTap() {
    if (widget.onTap == null) {
      setState(() {
        widget.revealed = true;
      });
    }
    else widget.onTap!.call();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      if (widget.revealed == true && _controller.status != AnimationStatus.forward) _controller.forward();
      else if (widget.revealed == false && _controller.status != AnimationStatus.reverse) _controller.reverse();
    });

    return GestureDetector(
      onTap: _onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) => Card(
          color: Color.lerp(getTeamColor(widget.teamNumber), Colors.grey[200], _controller.value),
          child: Stack(
            fit: StackFit.expand,
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
                  clipper: ConcentricClipper(progress: _controller.value, verticalPosition: 1),
                  child: widget.revealed == true
                      ? widget.card != null
                          ? Container(
                            color: Colors.grey[200],
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: CardViewWidget(widget.card!),
                            ),
                          )
                          : Text("Wenn du das liest ist ein unerwarteter Fehler aufgetreten.")
                      : Text("Diesen Text Sollte man nicht lesen können, denn die Karte ist versteckt")),
            ],
          ),
        ),
      ),
    );
  }
}
