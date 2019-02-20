import 'package:flutter/material.dart';
import 'gesture2.dart';

class _GesturePainter extends CustomPainter {
  const _GesturePainter({
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
    final double radius = size.width / 2.0 * zoom;

    final Paint paint = Paint();

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_GesturePainter oldPainter) {
    return oldPainter.zoom != zoom
        || oldPainter.offset != offset

        || oldPainter.scaleEnabled != scaleEnabled;

  }
}

class GestureDemo extends StatefulWidget {
  @override
  GestureDemoState createState() => GestureDemoState();
}

class GestureDemoState extends State<GestureDemo> {

  Offset _startingFocalPoint;

  Offset _previousOffset;
  Offset _offset = Offset.zero;

  double _previousZoom;
  double _zoom = 1.0;


  bool _scaleEnabled = true;

  void _handleScaleStart(ScaleStartDetails details) {
    setState(() {
      _startingFocalPoint = details.focalPoint;
      _previousOffset = _offset;
      _previousZoom = _zoom;
    });
  }

  void _handleScaleUpdate(ScaleUpdateDetails details) {
    setState(() {
      _zoom = _previousZoom * details.scale;

      // Ensure that item under the focal point stays in the same place despite zooming
      final Offset normalizedOffset = (_startingFocalPoint - _previousOffset) / _previousZoom;
      _offset = details.focalPoint - normalizedOffset * _zoom;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
        fit: StackFit.expand,
        children: <Widget>[
          GestureDetector(
              onScaleStart: _scaleEnabled ? _handleScaleStart : null,
              onScaleUpdate: _scaleEnabled ? _handleScaleUpdate : null,
              child: CustomPaint(
                  painter: _GesturePainter(
                      zoom: _zoom,
                      offset: _offset,
                      scaleEnabled: _scaleEnabled,
                  ),
                child: CustomPaint(
                    painter: GesturePainter2(
                      zoom: _zoom,
                      offset: _offset,
                      scaleEnabled: _scaleEnabled,
                    ),
              )
            ),
          )
        ]
    );
  }
}

void main() {
  runApp(MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
          appBar: AppBar(title: const Text('Gestures Demo')),
          body: GestureDemo()
      )
  ));
}