import 'package:flutter/material.dart';

class CanvasItem {
  GlobalKey _key = GlobalKey();

  GlobalKey get key => _key;

  Widget child;

  CanvasItemProperties properties;
  CanvasItem({this.child, this.properties});
}

class CanvasItemProperties {
  Offset offset;
  double width, height;
  double angle;
  double zoom;
  CanvasItemProperties({
    this.offset,
    this.width,
    this.height,
    this.angle = 0.0,
    this.zoom = 1,
  });
}
