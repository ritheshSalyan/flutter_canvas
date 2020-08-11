import 'dart:math';

import 'package:canvas/canvas/canvas_item.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';
import 'package:provider/provider.dart';

import 'canvas_controller.dart';
import 'package:flutter/material.dart';

class CanvasBoard extends StatelessWidget {
  final CanvasController controller;

  CanvasBoard({Key key, @required this.controller}) : super(key: key);
  final GlobalKey canvasKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      key: canvasKey,
      color: Colors.blue,
      child: ChangeNotifierProvider<CanvasController>(
          create: (context) => controller,
          child: Consumer<CanvasController>(
            builder: (context, viewModel, child) {
              return DragTarget<CanvasItem>(
                onAcceptWithDetails: (details) {
                  final RenderBox renderBox =
                      canvasKey.currentContext.findRenderObject();

                  final position = renderBox.localToGlobal(Offset.zero);

                  viewModel.onAccept(details.data, details.offset - position);
                },
                builder: (context, candidateData, rejectedData) {
                  //                  final RenderBox renderBox =
                  //                 canvasKey.currentContext.findRenderObject();

                  //  Offset offset =  renderBox?.localToGlobal(Offset.zero);
                  return SizedBox.expand(
                    child: Stack(
                      children: List<Widget>.from(
                        viewModel.items.map(
                          (e) => CanvasItemRender(
                            canvasKey: canvasKey,
                            e: e,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}

class CanvasItemRender extends StatefulWidget {
  CanvasItemRender({
    Key key,
    @required this.canvasKey,
    @required this.e,
  }) : super(key: key);
  CanvasItem e;
  final GlobalKey<State<StatefulWidget>> canvasKey;

  @override
  _CanvasItemRenderState createState() => _CanvasItemRenderState();
}

class _CanvasItemRenderState extends State<CanvasItemRender> {
  bool show = false;
  Matrix4 matrix = Matrix4.identity();
  @override
  Widget build(BuildContext context) {
    return Consumer<CanvasController>(
      builder: (context, viewModel, child) {
        // Transform(transform: null)
        return Stack(
          children: [
            ResizebleWidget(
              onNewSize: (double width, double height) {
                widget.e.properties.width = width;
                widget.e.properties.height = height;
                // viewModel.updateScale(widget.e, width, height);
              },
              onNewScale: (double zoom) {
                widget.e.properties.zoom = zoom;
              },
              onNewOffset: (Offset offset) {
                widget.e.properties.offset = offset;
              },
              offset: widget.e.properties.offset,
              child: widget.e.child,
            ),
          ],
        );
      },
    );
  }
}

class ResizebleWidget extends StatefulWidget {
  ResizebleWidget({
    this.child,
    this.onNewSize,
    @required this.offset,
    this.onNewScale,
    this.onNewOffset,
  });

  final Widget child;
  final void Function(double width, double height) onNewSize;
  final void Function(double zoom) onNewScale;
  final void Function(Offset offset) onNewOffset;
  final Offset offset;
  @override
  _ResizebleWidgetState createState() => _ResizebleWidgetState();
}

const ballDiameter = 30.0;

class _ResizebleWidgetState extends State<ResizebleWidget> {
  double height = 0; // = 500;
  double width = 0; //= 500;
  GlobalKey key = GlobalKey();
  double top = 0;
  double left = 0;

  double initX;
  double initY;

  bool show = false;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    print(angle % 360 > 90 && angle % 360 < 270);
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;

    //Convert Degree into radian
    double currentAngle = (angle.toInt() % 360) * (3.1415927 / 180);
    print("Cuurent Angle $currentAngle");

    //Calculation of position based on angle of rotation
    left = left + (dx) * cos(currentAngle) - (dy) * sin(currentAngle);
    top = top + (dx) * sin(currentAngle) + (dy) * cos(currentAngle);
    setState(() {});
  }

  double angle = 0;
  double zoom = 1;
  @override
  void initState() {
    super.initState();
    top = widget.offset.dy;
    left = widget.offset.dx;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        height = key.currentContext.size.height;
        width = key.currentContext.size.width;
        widget.onNewSize(width, height);
      });
    });
  }

  void panHandler(DragUpdateDetails d) {
    /// Pan location on the wheel
    bool onTop = d.localPosition.dy <= height; // radius;
    bool onLeftSide = d.localPosition.dx <= width; //radius;
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
    angle += rotationalChange * 0.5;
    // print(angle);
    setState(() {});
    // bool movingClockwise = rotationalChange > 0;
    // bool movingCounterClockwise = rotationalChange < 0;
    // notifyListeners();
    // Now do something interesting with these computations!
  }

  int getquaterTurns() {
    // quaterTurn =
    // return angle.toInt();
  }

  @override
  Widget build(BuildContext context) {
    print(angle.toInt());
    return RotationTransition(
      turns: AlwaysStoppedAnimation(-angle / 360),
      child: Stack(
        overflow: Overflow.visible,
        children: <Widget>[
          Positioned(
            top: top,
            left: left,
            child: Transform.scale(
              scale: zoom,
              child: MouseRegion(
                onEnter: (event) {
                  setState(() {
                    show = true;
                  });
                },
                onExit: (event) {
                  setState(() {
                    show = false;
                  });
                },
                child: Container(
                  key: key,
                  height: height == 0.0 ? null : height,
                  width: width == 0.0 ? null : width,
                  color: Colors.transparent,
                  child: widget.child,
                ),
              ),
            ),
          ),
          Positioned(
            top: top,
            left: left,
            child: GestureDetector(
              onPanStart: _handleDrag,
              onPanUpdate: _handleUpdate,
              child: Transform.scale(
                scale: zoom,
                child: Container(
                  // key: key,
                  height: height == 0 ? null : height,
                  width: width == 0 ? null : width,
                  color: Colors.transparent,
                  // child: Opacity(opacity: 0,),
                ),
              ),
            ),
          ),
          // top left
          Positioned(
            top: top - (height * zoom - height) / 2 - ballDiameter / 2,
            left: left - (width * zoom - width) / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              show: show,
              onDrag: (dx, dy) {
                var mid = dx + dy;
                var zoomRate = (width + height - mid) / (width + height);
                setState(() {
                  zoom = zoom * pow(zoomRate, 2);
                  widget.onNewScale(zoom);
                });
              },
            ),
          ),

          // top right
          Positioned(
            top: top - (height * zoom - height) / 2 - ballDiameter / 2,
            left: left + (width * zoom - width) / 2 + width - ballDiameter / 2,
            child: ManipulatingBall(
              show: show,
              onDrag: (dx, dy) {
                var mid = (-dx + dy);
                var zoomRate = (width + height - mid) / (width + height);

                setState(() {
                  zoom = zoom * pow(zoomRate, 2);
                  widget.onNewScale(zoom);
                });
              },
            ),
          ),
          Positioned(
            top: top + (height * zoom - height) / 2 + height - ballDiameter / 2,
            left: left + (width * zoom - width) / 2 + width - ballDiameter / 2,
            child: GestureDetector(
              onPanUpdate: panHandler,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
              ),
              //   onPanUpdate: (dx, dy) {
              //     var mid = (-dx - dy);
              //     var zoomRate = (width + height - mid) / (width + height);
              //     setState(() {
              //       zoom = zoom * pow(zoomRate, 2);
              //     });
              //   },
            ),
          ),
          // bottom right
          Positioned(
            top: top + (height * zoom - height) / 2 + height - ballDiameter / 2,
            left: left + (width * zoom - width) / 2 + width - ballDiameter / 2,
            child: ManipulatingBall(
              show: show,
              onDrag: (dx, dy) {
                var mid = (-dx - dy);
                var zoomRate = (width + height - mid) / (width + height);
                setState(() {
                  zoom = zoom * pow(zoomRate, 2);
                  widget.onNewScale(zoom);
                });
              },
            ),
          ),

          // bottom left
          Positioned(
            top: top + (height * zoom - height) / 2 + height - ballDiameter / 2,
            left: left - (width * zoom - width) / 2 - ballDiameter / 2,
            child: ManipulatingBall(
              show: show,
              onDrag: (dx, dy) {
                var mid = (dx - dy);
                var zoomRate = (width + height - mid) / (width + height);
                setState(() {
                  zoom = zoom * pow(zoomRate, 2);
                  widget.onNewScale(zoom);
                });
              },
            ),
          ),

          // center center
          // Positioned(
          //   top: top + height / 2 - ballDiameter / 2,
          //   left: left + width / 2 - ballDiameter / 2,
          //   child: ManipulatingBall(
          //     onDrag: (dx, dy) {
          //       setState(() {
          //         top = top + dy;
          //         left = left + dx;
          //       });
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class ManipulatingBall extends StatefulWidget {
  ManipulatingBall({Key key, this.onDrag, @required this.show});

  final Function onDrag;
  final bool show;
  @override
  _ManipulatingBallState createState() => _ManipulatingBallState();
}

class _ManipulatingBallState extends State<ManipulatingBall> {
  double initX;
  double initY;

  _handleDrag(details) {
    setState(() {
      initX = details.globalPosition.dx;
      initY = details.globalPosition.dy;
    });
  }

  _handleUpdate(details) {
    var dx = details.globalPosition.dx - initX;
    var dy = details.globalPosition.dy - initY;
    initX = details.globalPosition.dx;
    initY = details.globalPosition.dy;
    widget.onDrag(dx, dy);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: _handleDrag,
      onPanUpdate: _handleUpdate,
      child: Opacity(
        opacity: widget.show ? 1 : 0,
        child: Container(
          width: ballDiameter,
          height: ballDiameter,
          decoration: BoxDecoration(
            color: Colors.yellow.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
