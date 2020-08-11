import 'package:flutter/material.dart';

import 'canvas_item.dart';

class CanvasItemWidget extends StatelessWidget {
  final Widget child;

  const CanvasItemWidget({Key key, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Draggable<CanvasItem>(
        data: CanvasItem(
            child: child, properties: CanvasItemProperties()),
        child: Container(
          child: child,
        ),
        feedback: Opacity(
          opacity: 0.5,
          child: child,
        ));
  }
}
