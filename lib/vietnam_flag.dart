import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_shaders/flutter_shaders.dart';
import 'package:vietnam_flag/const.dart';

class VietnamFlag extends StatefulWidget {
  const VietnamFlag({
    super.key,
    required this.flagSize,
  });

  final Size flagSize;

  @override
  State<VietnamFlag> createState() => _VietnamFlagState();
}

class _VietnamFlagState extends State<VietnamFlag>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 6),
      vsync: this,
    )..repeat(period: const Duration(seconds: 3));
    animation = Tween<double>(begin: 0, end: 2 * pi).animate(controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ShaderBuilder(
          (context, shader, _) {
            return AnimatedSampler(
              (image, size, canvas) {
                ShaderHelper.configureShader(
                  shader,
                  size,
                  image,
                  time: controller.value * 2,
                  pointer: Offset.zero,
                );
                ShaderHelper.drawShaderRect(shader, size, canvas);
              },
              child: CustomPaint(
                size: widget.flagSize,
                painter: VietNamFlagPainter(),
              ),
            );
          },
          assetKey: "shaders/ripple.frag",
        );
      },
    );
  }
}

class VietNamFlagPainter extends CustomPainter {
  VietNamFlagPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    final Paint rectanglePaint = Paint()
      ..color = VietnamFlagColorPalette.red
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTRB(0, 0, width, height), rectanglePaint);

    final Paint yellowPaint = Paint()
      ..color = VietnamFlagColorPalette.yellow
      ..style = PaintingStyle.fill;

    final radius = size.width / 5;
    final center = Offset(width / 2, height / 2);
    final path = Path();
    final List<Offset> points = [];

    for (int i = 0; i < vertexOfStar; i++) {
      final double currentAngle = -pi / 2 + i * angleStep;
      final double x = center.dx + (radius) * cos(currentAngle);
      final double y = center.dy + (radius) * sin(currentAngle);

      points.add(Offset(x, y));
    }

    path
      ..moveTo(points[0].dx, points[0].dy)
      ..lineTo(points[2].dx, points[2].dy)
      ..lineTo(points[4].dx, points[4].dy)
      ..lineTo(points[1].dx, points[1].dy)
      ..lineTo(points[3].dx, points[3].dy)
      ..close();

    canvas.drawPath(path, yellowPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class ShaderHelper {
  static void configureShader(
    ui.FragmentShader shader,
    ui.Size size,
    ui.Image image, {
    required double time,
    required Offset pointer,
  }) {
    shader
      ..setFloat(0, size.width) // iResolution
      ..setFloat(1, size.height) // iResolution
      ..setFloat(2, pointer.dx) // iMouse
      ..setFloat(3, pointer.dy) // iMouse
      ..setFloat(4, time) // iTime
      ..setImageSampler(0, image); // image
  }

  static void drawShaderRect(
    ui.FragmentShader shader,
    ui.Size size,
    ui.Canvas canvas,
  ) {
    canvas.drawRect(
      Rect.fromLTWH(
        0,
        0,
        size.width,
        size.height,
      ),
      Paint()..shader = shader,
    );
  }
}
