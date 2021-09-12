import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tabu_geo_new/models/game.dart';
import 'package:tabu_geo_new/util/team_colors.dart';

class LinearScoreBar extends StatefulWidget {

  final int totalCards;
  final List<SingleTeamStatistic> teamStatistics;

  LinearScoreBar({Key? key, required this.totalCards, required this.teamStatistics}) : super(key: key);


  @override
  State<LinearScoreBar> createState() => _LinearScoreBarState();
}

class _LinearScoreBarState extends State<LinearScoreBar> {
  List<Widget> _generateBarWidgets(double maxWidth) {
    List<Widget> widgets = List.empty(growable: true);


    int totalPoints = widget.totalCards;

    int currentTeamNumber = 1;
    for (var v in widget.teamStatistics) {
      var guessedCorrectly = v.guessedCards;
      var width = guessedCorrectly / totalPoints * maxWidth;

      widgets.add(_genCont(width, getTeamColor(currentTeamNumber)));

      //print("width team $currentTeamNumber: ${(v / totalPoints) * maxWidth}");
      currentTeamNumber++;
    }

    int failedTotal = widget.teamStatistics.fold(0, (value, element) => value += element.failedCards);


    widgets.add(Expanded(child: Container(color: Colors.grey[300],)));
    widgets.add(_genCont(failedTotal / totalPoints * maxWidth, Colors.grey[800]!));
    return widgets;
  }

  Widget _genCont(double width, Color color) {
    return AnimatedContainer(duration: Duration(milliseconds: 300), curve: Curves.easeInCirc, color: color, width: width,);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      //print(constraints.maxWidth);

      return SizedBox(height: 10, width: double.infinity, child: Row(
        children: _generateBarWidgets(constraints.maxWidth),
        mainAxisSize: MainAxisSize.max,
      ),);
    },);
  }
}

