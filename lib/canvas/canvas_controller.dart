import 'package:canvas/canvas/canvas_item_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'canvas_item.dart';

class CanvasController with ChangeNotifier {
  List<CanvasItem> items = [];
  void onAccept(CanvasItem item, Offset offset) {
    item.properties.offset = offset;
    items.add(item);
    notifyListeners();
  }

  void updatePosition(CanvasItem item, Offset newPosition) {
    int pos = items.indexOf(item);
    item.properties.offset = newPosition;
    items.removeAt(pos);
    items.insert(pos, item);
    notifyListeners();
  }

  void updateScale(CanvasItem e, double x, double y) {
    int pos = items.indexOf(e);
    e.properties.width = x;
    //((e.properties.width ?? e.key.currentContext.size.width) + x).abs();
    e.properties.height = y;
    // ((e.properties.height ?? e.key.currentContext.size.height) + y).abs();
    items.removeAt(pos);
    items.insert(pos, e);
    notifyListeners();
  }

  void panHandler(CanvasItem e, DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= e.properties.height; // radius;
    bool onLeftSide = d.localPosition.dx <= e.properties.width; //radius;
    bool onRightSide = !onLeftSide;
    bool onBottom = !onTop;

    /// Pan movements
    bool panUp = d.delta.dy <= 0.0;
    bool panLeft = d.delta.dx <= 0.0;
    bool panRight = !panLeft;
    bool panDown = !panUp;

    /// Absoulte change on axis
    double yChange = d.delta.dy.abs();
    double xChange = d.delta.dx.abs();

    /// Directional change on wheel
    double verticalRotation = (onRightSide && panDown) || (onLeftSide && panUp)
        ? yChange
        : yChange * -1;

    double horizontalRotation =
        (onTop && panRight) || (onBottom && panLeft) ? xChange : xChange * -1;

    // Total computed change
    double rotationalChange = verticalRotation + horizontalRotation;
    e.properties.angle += rotationalChange;

    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;
    // notifyListeners();
    // Now do something interesting with these computations!
  }
}
