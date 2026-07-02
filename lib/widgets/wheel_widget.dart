import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/wheel_reward.dart';

class WheelWidget extends StatefulWidget {
  final int targetIndex;
  final bool spinning;
  final VoidCallback onSpinComplete;

  const WheelWidget({
    super.key,
    required this.targetIndex,
    required this.spinning,
    required this.onSpinComplete,
  });

  @override
  State<WheelWidget> createState() => _WheelWidgetState();
}

class _WheelWidgetState extends State<WheelWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  bool _wasSpinning = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 4000),
      vsync: this,
    );
    _rotationAnimation = const AlwaysStoppedAnimation(0);
  }

  @override
  void didUpdateWidget(WheelWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.spinning && !_wasSpinning) {
      _startSpin();
    }
    _wasSpinning = widget.spinning;
  }

  void _startSpin() {
    final segmentCount = allWheelSegments.length;
    final segmentAngle = (2 * math.pi) / segmentCount;
    final targetAngle = -widget.targetIndex * segmentAngle - segmentAngle / 2;
    final fullSpins = 5 * 2 * math.pi;
    final totalRotation = fullSpins + targetAngle;

    _rotationAnimation = Tween<double>(
      begin: 0,
      end: totalRotation,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.reset();
    _controller.forward().then((_) {
      widget.onSpinComplete();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final segments = allWheelSegments;
    final segmentAngle = (2 * math.pi) / segments.length;

    return SizedBox(
      width: 300,
      height: 300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _rotationAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value,
                child: child,
              );
            },
            child: CustomPaint(
              size: const Size(280, 280),
              painter: _WheelPainter(segments: segments),
            ),
          ),
          Positioned(
            top: 0,
            child: CustomPaint(
              size: const Size(24, 20),
              painter: _PointerPainter(),
            ),
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF1A1A24),
              border: Border.all(color: const Color(0xFFFFD600), width: 3),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFFD600).withAlpha(40),
                  blurRadius: 10,
                ),
              ],
            ),
            child: const Icon(Icons.star, color: Color(0xFFFFD600), size: 24),
          ),
        ],
      ),
    );
  }
}

class _WheelPainter extends CustomPainter {
  final List<WheelSegment> segments;

  _WheelPainter({required this.segments});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final segmentAngle = (2 * math.pi) / segments.length;

    for (int i = 0; i < segments.length; i++) {
      final startAngle = i * segmentAngle - math.pi / 2;
      final paint = Paint()
        ..color = segments[i].color.withAlpha(i.isEven ? 200 : 160)
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        paint,
      );

      final borderPaint = Paint()
        ..color = const Color(0xFF1A1A24)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        segmentAngle,
        true,
        borderPaint,
      );

      final textAngle = startAngle + segmentAngle / 2;
      final textRadius = radius * 0.65;
      final textCenter = Offset(
        center.dx + textRadius * math.cos(textAngle),
        center.dy + textRadius * math.sin(textAngle),
      );

      canvas.save();
      canvas.translate(textCenter.dx, textCenter.dy);
      canvas.rotate(textAngle + math.pi / 2);

      final textPainter = TextPainter(
        text: TextSpan(
          text: segments[i].label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            shadows: [Shadow(color: Colors.black54, blurRadius: 2)],
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      )..layout(maxWidth: radius * 0.5);

      textPainter.paint(
        canvas,
        Offset(-textPainter.width / 2, -textPainter.height / 2),
      );
      canvas.restore();
    }

    final outerBorder = Paint()
      ..color = const Color(0xFFFFD600)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, outerBorder);
  }

  @override
  bool shouldRepaint(covariant _WheelPainter oldDelegate) => false;
}

class _PointerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFD600)
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
