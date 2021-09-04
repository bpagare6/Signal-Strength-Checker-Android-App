import 'dart:ui';
import 'dart:math';
import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  double currentProgress;
  bool darkModeEnabled;

  CircleProgress(this.currentProgress, this.darkModeEnabled);

  @override
  void paint(Canvas canvas, Size size) {
    // Draw Outer Circle
    Offset centerOuter = Offset(size.width / 2, size.height / 2);
    double radiusOuter = min(size.width / 2, size.height / 2);

    Paint outerCircle = Paint()
      ..strokeWidth = 20
      ..color = (darkModeEnabled) ? Color(0xFF212121) : Color(0xFF1D2D57)
      ..style = PaintingStyle.stroke;

    var gradient1 = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment(0.5, 0.0),
      stops: [0.0, 0.7, 1],
      colors: [Colors.lightGreen, Colors.lightBlueAccent, Colors.cyan],
    );

    Paint completeArcOuter = Paint()
      ..strokeWidth = 20
      ..shader = gradient1.createShader(
          Rect.fromCircle(center: centerOuter, radius: radiusOuter))
      ..style = PaintingStyle.stroke;

    canvas.drawArc(Rect.fromCircle(center: centerOuter, radius: radiusOuter),
        4 / 5 * pi, 7 / 5 * pi, false, outerCircle);
    double angle = 7 / 5 * pi * (currentProgress / 100);
    canvas.drawArc(Rect.fromCircle(center: centerOuter, radius: radiusOuter),
        4 / 5 * pi, angle, false, completeArcOuter);

    // Draw Inner Circle
    Offset centerInner = Offset(size.width / 2, size.height / 2);
    double radiusInner = min(size.width / 2, size.height / 2) - 20;

    Paint innerCircle = Paint()
      ..strokeWidth = 30
      ..color = (darkModeEnabled) ? Color(0xFF303030) : Colors.white
      ..style = PaintingStyle.stroke;

    var gradient2 = RadialGradient(
      colors: <Color>[
        Color(0xFF22FFDD).withOpacity(0.0),
        Color(0xFF22FFDD).withOpacity(0.1),
        Color(0xFF22FFDD).withOpacity(0.2),
        Color(0xFF22FFDD).withOpacity(0.3),
      ],
      stops: [0.0, 0.3, 0.6, 1.0],
    );

    Paint completeArcInner = Paint()
      ..strokeWidth = 30
      ..shader = gradient2.createShader(
          Rect.fromCircle(center: centerInner, radius: radiusInner))
      ..style = PaintingStyle.stroke;

    canvas.drawArc(Rect.fromCircle(center: centerInner, radius: radiusInner),
        4 / 5 * pi, 7 / 5 * pi, false, innerCircle);
    canvas.drawArc(Rect.fromCircle(center: centerInner, radius: radiusInner),
        4 / 5 * pi, angle, false, completeArcInner);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
