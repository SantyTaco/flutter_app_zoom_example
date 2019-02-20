import 'package:flutter/material.dart';

class GesturePainter2 extends CustomPainter {
  const GesturePainter2({
    this.zoom,
    this.offset,
    this.scaleEnabled,
  });

  final double zoom;
  final Offset offset;
  final bool scaleEnabled;


  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = size.center(Offset.zero) * zoom + offset;
    final double radius = size.width / 5.0 * zoom;

    final Paint paint = Paint();
    paint.color = Colors.orange;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(GesturePainter2 oldPainter) {
    return oldPainter.zoom != zoom
        || oldPainter.offset != offset

        || oldPainter.scaleEnabled != scaleEnabled;

  }
}