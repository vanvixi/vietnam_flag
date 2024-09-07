import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vietnam_flag/const.dart';

class VietnamFlagSketch extends StatefulWidget {
  const VietnamFlagSketch({
    super.key,
    required this.flagSize,
    required this.onPaintDone,
  });

  final Size flagSize;
  final VoidCallback onPaintDone;

  @override
  State<VietnamFlagSketch> createState() => _VietnamFlagSketchState();
}

class _VietnamFlagSketchState extends State<VietnamFlagSketch> with TickerProviderStateMixin {
  late final AnimationController _rectangleController;
  late final Animation<double> _rectangleAnimation;

  late final AnimationController _diagonalRectangleController;
  late final Animation<double> _diagonalRectangleAnimation;

  late final AnimationController _radiusLineController;
  late final Animation<double> _radiusLineAnimation;

  late final AnimationController _circleController;
  late final Animation<double> _circleAnimation;

  late final AnimationController _pentagonAndStarController;
  late final Animation<double> _pentagonAndStarAnimation;

  Animation<double> animateBy(AnimationController c) => Tween<double>(begin: 0.0, end: 1.0).animate(c);

  @override
  void initState() {
    super.initState();
    _rectangleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _rectangleAnimation = animateBy(_rectangleController);

    _diagonalRectangleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _diagonalRectangleAnimation = animateBy(_diagonalRectangleController);

    _radiusLineController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _radiusLineAnimation = animateBy(_radiusLineController);

    _circleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    _circleAnimation = animateBy(_circleController);

    _pentagonAndStarController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    );
    _pentagonAndStarAnimation = animateBy(_pentagonAndStarController);

    _rectangleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onStartPaintDiagonalRectangle();
      }
    });

    _diagonalRectangleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onStartPaintRadiusLine();
      }
    });

    _radiusLineController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onStartPaintCircle();
      }
    });

    _circleController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        onStartPaintPentagonAndStar();
      }
    });

    onStartPaintRectangle();
  }

  @override
  void dispose() {
    _rectangleController.dispose();
    _diagonalRectangleController.dispose();
    _circleController.dispose();
    _pentagonAndStarController.dispose();
    super.dispose();
  }

  void onStartPaintRectangle() => _rectangleController.forward();

  void onStartPaintDiagonalRectangle() => _diagonalRectangleController.forward();

  void onStartPaintRadiusLine() => _radiusLineController.forward();

  void onStartPaintCircle() => _circleController.forward();

  Future<void> onStartPaintPentagonAndStar() async {
    await Future.delayed(const Duration(milliseconds: 300));
    if (!mounted) return;
    await _pentagonAndStarController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    widget.onPaintDone();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _diagonalRectangleController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.flagSize,
              painter: DiagonalRectanglePainter(_diagonalRectangleAnimation),
            );
          },
        ),
        AnimatedBuilder(
          animation: _rectangleController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.flagSize,
              painter: RectanglePainter(_rectangleAnimation),
            );
          },
        ),
        AnimatedBuilder(
          animation: _radiusLineController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.flagSize,
              painter: RadiusLinePainter(_radiusLineAnimation),
            );
          },
        ),
        AnimatedBuilder(
          animation: _circleController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.flagSize,
              painter: CirclePainter(_circleAnimation),
            );
          },
        ),
        AnimatedBuilder(
          animation: _pentagonAndStarController,
          builder: (context, child) {
            return CustomPaint(
              size: widget.flagSize,
              painter: PentagonAndStarPainter(_pentagonAndStarAnimation),
            );
          },
        ),
      ],
    );
  }
}
final paintSketch = Paint()
  ..color = Colors.grey
  ..style = PaintingStyle.stroke
  ..strokeWidth = 1.0;

class RectanglePainter extends CustomPainter {
  final Animation<double> animation;

  RectanglePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = VietnamFlagColorPalette.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, -2)
      ..close();

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animation.value,
      );
      canvas.drawPath(extractPath, paint);
    }
  }

  @override
  bool shouldRepaint(RectanglePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class DiagonalRectanglePainter extends CustomPainter {
  final Animation<double> animation;

  DiagonalRectanglePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, size.height)
      ..moveTo(size.width, 0)
      ..lineTo(0, size.height)
      ..close();

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animation.value,
      );
      canvas.drawPath(extractPath, paintSketch);
    }
  }

  @override
  bool shouldRepaint(DiagonalRectanglePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class RadiusLinePainter extends CustomPainter {
  final Animation<double> animation;

  RadiusLinePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 5;
    final center = Offset(size.width / 2, size.height / 2);

    final path = Path()
      ..moveTo(center.dx, center.dy)
      ..lineTo(center.dx, center.dy - radius)
      ..close();

    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(
        0.0,
        pathMetric.length * animation.value,
      );
      canvas.drawPath(extractPath, paintSketch);
    }
  }

  @override
  bool shouldRepaint(RadiusLinePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class CirclePainter extends CustomPainter {
  final Animation<double> animation;

  CirclePainter(this.animation) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 5;
    final center = Offset(size.width / 2, size.height / 2);

    final path = Path()
      ..addArc(
        Rect.fromCircle(center: center, radius: radius),
        -pi / 2,
        2 * pi * animation.value,
      );
    canvas.drawPath(path, paintSketch);
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class PentagonAndStarPainter extends CustomPainter {
  PentagonAndStarPainter(this.animation) : super(repaint: animation);

  final Animation<double> animation;

  final List<Offset> points = [];

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 5;
    final center = Offset(size.width / 2, size.height / 2);
    final path = Path();

    if (points.isEmpty) {
      for (int i = 0; i < vertexOfStar; i++) {
        final double currentAngle = -pi / 2 + i * angleStep;
        final double x = center.dx + (radius) * cos(currentAngle);
        final double y = center.dy + (radius) * sin(currentAngle);

        points.add(Offset(x, y));
      }

      path
        // Paint Pentagon
        ..moveTo(points[0].dx, points[0].dy)
        ..lineTo(points[1].dx, points[1].dy)
        ..lineTo(points[2].dx, points[2].dy)
        ..lineTo(points[3].dx, points[3].dy)
        ..lineTo(points[4].dx, points[4].dy)
        // Paint Star
        ..lineTo(points[0].dx, points[0].dy)
        ..lineTo(points[2].dx, points[2].dy)
        ..lineTo(points[4].dx, points[4].dy)
        ..lineTo(points[1].dx, points[1].dy)
        ..lineTo(points[3].dx, points[3].dy)
        ..close();
    }

    final pathMetrics = path.computeMetrics();
    final animatedPath = Path();
    for (final metric in pathMetrics) {
      animatedPath.addPath(
        metric.extractPath(0.0, metric.length * animation.value),
        Offset.zero,
      );
    }

    canvas.drawPath(animatedPath, paintSketch);
  }

  @override
  bool shouldRepaint(PentagonAndStarPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
