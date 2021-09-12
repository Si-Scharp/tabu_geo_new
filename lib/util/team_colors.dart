
import 'package:flutter/material.dart';

Color getTeamColor(int teamNumber) {
  switch (teamNumber) {
    case 1: return Colors.red;
    case 2: return Colors.blue;
    case 3: return Colors.orange;
    case 4: return Colors.green;
    case 5: return Colors.purple;
    case 6: return Colors.brown;
    case 7: return Colors.lightGreenAccent;
    case 8: return Colors.indigoAccent;
    case 9: return Colors.yellow;
    case 10: return Colors.teal;

    default: return Colors.black;
  }
}