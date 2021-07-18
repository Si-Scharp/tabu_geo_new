import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DragFade extends StatefulWidget {
  const DragFade({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  State<DragFade> createState() => _DragFadeState();
}

class _DragFadeState extends State<DragFade> {
  Offset offset = new Offset(0,0);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Transform.translate(
        transformHitTests: false,
        offset: offset,
        child: Opacity(opacity: (1 - offset.dx.abs() / 300).clamp(0.0, 1.0) ,child: widget.child)
      ),
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          offset += details.delta;
        });
      },
      onPanEnd: (details) {
        setState(() {
          offset = Offset(0,0);
        });
      },
    );
  }
}
