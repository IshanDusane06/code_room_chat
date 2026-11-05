import 'package:flutter/material.dart';

class AppIcon extends StatelessWidget {
  const AppIcon._({
    required this.size,
    required this.color,
    required this.painter,
  });

  factory AppIcon.key({required Size size, required Color color}) =>
      AppIcon._(size: size, color: color, painter: _KeyPainter(color));

  factory AppIcon.back({required double size, required Color color}) =>
      AppIcon._(
        size: Size.square(size),
        color: color,
        painter: _BackPainter(color),
      );

  factory AppIcon.send({required double size, required Color color}) =>
      AppIcon._(
        size: Size.square(size),
        color: color,
        painter: _SendPainter(color),
      );

  final Size size;
  final Color color;
  final CustomPainter painter;

  @override
  Widget build(BuildContext context) => Center(
    child: CustomPaint(size: size, painter: painter),
  );
}

abstract class _StrokePainter extends CustomPainter {
  const _StrokePainter(this.color, this.gridWidth, this.strokeWidth);

  final Color color;
  final double gridWidth;
  final double strokeWidth;

  void draw(Canvas canvas, Paint stroke);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / gridWidth;
    canvas.scale(scale);
    draw(
      canvas,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_StrokePainter oldDelegate) => oldDelegate.color != color;
}

class _KeyPainter extends _StrokePainter {
  const _KeyPainter(Color color) : super(color, 34, 2.7);

  @override
  void draw(Canvas canvas, Paint stroke) {
    canvas.drawCircle(const Offset(8, 8), 6.6, stroke);
    canvas.drawCircle(const Offset(8, 8), 2.3, Paint()..color = color);
    final shaft = Path()
      ..moveTo(14, 4.6)
      ..lineTo(29, 4.6)
      ..lineTo(33, 8.4)
      ..lineTo(29, 12.6)
      ..lineTo(26.8, 10.6)
      ..lineTo(24.4, 13)
      ..lineTo(22, 10.6)
      ..lineTo(19.6, 12.6)
      ..lineTo(17.4, 11.4)
      ..lineTo(14, 11.4);
    canvas.drawPath(shaft, stroke);
  }
}

class _BackPainter extends _StrokePainter {
  const _BackPainter(Color color) : super(color, 24, 2.2);

  @override
  void draw(Canvas canvas, Paint stroke) {
    final chevron = Path()
      ..moveTo(15.5, 4.5)
      ..lineTo(8, 12)
      ..lineTo(15.5, 19.5);
    canvas.drawPath(chevron, stroke);
  }
}

class _SendPainter extends _StrokePainter {
  const _SendPainter(Color color) : super(color, 24, 2);

  @override
  void draw(Canvas canvas, Paint stroke) {
    final plane = Path()
      ..moveTo(22, 2)
      ..lineTo(15, 22)
      ..lineTo(11, 13)
      ..lineTo(2, 9)
      ..close()
      ..moveTo(22, 2)
      ..lineTo(11, 13);
    canvas.drawPath(plane, stroke);
  }
}
