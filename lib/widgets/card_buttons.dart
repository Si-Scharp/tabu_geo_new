import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';




class CardButtons extends StatefulWidget {

  final VoidCallback? clickedCorrectButton;
  final VoidCallback? clickedWrongButton;
  final VoidCallback? clickedUndoButton;
  final VoidCallback? clickedDoneButton;
  final ButtonState buttonState;

  const CardButtons({
    Key? key,
    this.buttonState = ButtonState.unspecified,
    this.clickedCorrectButton,
    this.clickedWrongButton,
    this.clickedUndoButton,
    this.clickedDoneButton,
  }) : super(key: key);

  @override
  _CardButtonsState createState() => _CardButtonsState();
}

class _CardButtonsState extends State<CardButtons> with SingleTickerProviderStateMixin {
  late _CardButtonAnimationController _animationController;

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _animationController = _CardButtonAnimationController(vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if ((widget.buttonState) != _animationController.state) _animationController.animateToState(widget.buttonState);
    });

    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Row(
          children: [
            Expanded(
              //wrong button
              flex: _animationController.wrongFraction,
              child: ElevatedButton(
                  onPressed: () {


                    if (_animationController.state == ButtonState.wrong) {
                      widget.clickedDoneButton?.call();
                    } else if (_animationController.state == ButtonState.correct) {
                      widget.clickedUndoButton?.call();
                      //_animationController.animateToState(ButtonState.unspecified);
                    } else if (_animationController.state == ButtonState.unspecified) {
                      widget.clickedWrongButton?.call();
                      //_animationController.animateToState(ButtonState.wrong);
                    }
                  },
                  style: _btnSt(_animationController.wrongBtnCol),

                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 150),
                    child: Icon(_animationController.wrongBtnIcon, key: ValueKey<String>(_animationController.wrongBtnIcon.toString())),
                  )),
            ),
            Expanded(
              //correct button
              flex: _animationController.correctFraction,
              child: ElevatedButton(
                  onPressed: () {
                    if (_animationController.state == ButtonState.wrong) {
                      widget.clickedUndoButton?.call();
                      //_animationController.animateToState(ButtonState.unspecified);
                    } else if (_animationController.state == ButtonState.correct) {
                      widget.clickedDoneButton?.call();
                    } else if (_animationController.state == ButtonState.unspecified) {
                      widget.clickedCorrectButton?.call();
                      //_animationController.animateToState(ButtonState.correct);
                    }
                  },

                  style: _btnSt(_animationController.correctBtnCol),
                  child: AnimatedSwitcher(

                    duration: Duration(milliseconds: 150),
                    child: Icon(_animationController.correctBtnIcon, key: ValueKey<String>(_animationController.correctBtnIcon.toString())),
                  )),
            ),
          ],
        );
      },
    );
  }
}



class _CardButtonAnimationController with ChangeNotifier {
  final AnimationController animationController;

  _CardButtonAnimationController({required TickerProvider vsync})
      : this.withCustomAnimationController(
            AnimationController(vsync: vsync, duration: Duration(milliseconds: 150)));

  _CardButtonAnimationController.withCustomAnimationController(this.animationController) {
    animationController.addListener(() {
      notifyListeners();
    });
    animationController.addStatusListener((status) {});
  }

  double get _animCurveVal => Curves.easeInCirc.transform(animationController.value);

  void animateToState(ButtonState state) {
    if (_state != state) {
      if (state == ButtonState.correct || state == ButtonState.wrong) {
        _animatingFromState = null;
        animationController.forward();
      }
      if (state == ButtonState.unspecified) {
        _animatingFromState = _state;
        animationController.reverse();
      }

      _state = state;
    }
  }

  ButtonState _state = ButtonState.unspecified;
  ButtonState? _animatingFromState;

  ButtonState get state => _state;

  IconData get wrongBtnIcon => state == ButtonState.correct ? Icons.undo : Icons.close;

  IconData get correctBtnIcon => state == ButtonState.wrong ? Icons.undo : Icons.check;

  Color get wrongBtnCol {
    switch (_state) {
      case ButtonState.correct:
        return Color.lerp(Colors.red, Colors.grey, _animCurveVal)!;
      case ButtonState.wrong:
        return Color.lerp(Colors.red, Colors.blue, _animCurveVal)!;
      case ButtonState.unspecified:
        return Colors.red;
    }
  }

  Color get correctBtnCol {
    switch (_state) {
      case ButtonState.wrong:
        return Color.lerp(Colors.green, Colors.grey, _animCurveVal)!;
      case ButtonState.correct:
        return Color.lerp(Colors.green, Colors.blue, _animCurveVal)!;
      case ButtonState.unspecified:
        return Colors.green;
    }
  }

  int get wrongFraction {
    if (_animatingFromState == ButtonState.correct || _state == ButtonState.correct)
      return 100 - correctFraction;

    if (_state == ButtonState.wrong || _state == ButtonState.unspecified)
      return lerpDouble(50, 70, _animCurveVal)!.toInt();

    throw Error();
  }

  int get correctFraction {
    if (_animatingFromState == ButtonState.wrong || _state == ButtonState.wrong) return 100 - wrongFraction;

    if (_state == ButtonState.correct || _state == ButtonState.unspecified)
      return lerpDouble(50, 70, _animCurveVal)!.toInt();

    throw Error();
  }
}

enum ButtonState { unspecified, correct, wrong }

ButtonStyle _btnSt(Color color) => ButtonStyle(backgroundColor: MaterialStateProperty.all(color));
