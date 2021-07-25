import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:stacked/stacked.dart';

typedef DropCallback = void Function(bool result);

class DragFade extends StatefulWidget {
  const DragFade(
      {Key? key, required this.child, this.maxDrag = 300, this.onDrop})
      : super(key: key);

  final double maxDrag;
  final Widget child;

  final DropCallback? onDrop;

  @override
  State<DragFade> createState() => _DragFadeState();
}

class _DragFadeState extends State<DragFade> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<_DragFadeModel>.reactive(
        viewModelBuilder: () => _DragFadeModel(maxDrag: widget.maxDrag),
        builder: (context, model, child) =>
            Stack(alignment: Alignment.center, children: [
              Container(
                clipBehavior: Clip.hardEdge,
                child: FractionallySizedBox(
                  alignment: model.fractionalOffset > 0.1
                      ? Alignment.centerLeft
                      : model.fractionalOffset < -0.1
                          ? Alignment.centerRight
                          : Alignment.center,
                  child: model.fractionalOffset > 0.1
                      ? Container(color: Colors.red)
                      : model.fractionalOffset < -0.1
                          ? Container(color: Colors.green)
                          : SizedBox.shrink(),
                  widthFactor: model.fractionalOffset.abs(),
                ),
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: (model.fractionalOffset > 0.1
                          ? Colors.red
                          : model.fractionalOffset < -0.1
                              ? Colors.green
                              : Colors.grey)
                      .shade200,
                  shape: BoxShape.circle,
                ),
              ),
              GestureDetector(
                  child: Transform.translate(
                      transformHitTests: false,
                      offset: model.offset,
                      child: Opacity(
                          opacity:
                              Curves.easeInOutCubic.transform(model.opacity),
                          child: widget.child)),
                  onPanUpdate: (details) => model.addDeltaDrag(details.delta),
                  onPanEnd: (details) {
                    if (model.fractionalOffset >= 1) widget.onDrop?.call(false);
                    else if (model.fractionalOffset <= -1) widget.onDrop?.call(true);
                    else model.resetOffset();
                  }),
            ]));
  }
}

class _DragFadeModel extends ChangeNotifier {
  double get opacity => 1 - (offset.dx.abs() / _maxDrag.abs()).clamp(0.0, 1.0);
  double get fractionalOffset => (offset.dx / _maxDrag.abs());
  Offset offset = Offset(0, 0);

  late double _maxDrag;
  _DragFadeModel({required double maxDrag}) {
    _maxDrag = maxDrag;
  }

  void resetOffset() {
    offset = Offset(0, 0);
    notifyListeners();
  }

  void addDeltaDrag(Offset offset) {
    this.offset += offset;
    notifyListeners();
  }
}
