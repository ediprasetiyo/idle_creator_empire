import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class TapButton extends StatefulWidget {
  final Color color;
  final IconData icon;
  final String label;
  final double coinsPerTap;
  final double viewsPerTap;
  final VoidCallback onTap;

  const TapButton({
    super.key,
    required this.color,
    required this.icon,
    required this.label,
    required this.coinsPerTap,
    required this.viewsPerTap,
    required this.onTap,
  });

  @override
  State<TapButton> createState() => _TapButtonState();
}

class _TapButtonState extends State<TapButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final List<_FloatingText> _floatingTexts = [];
  int _nextId = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) => _controller.reverse());
    widget.onTap();

    final random = Random();
    final id = _nextId++;
    setState(() {
      _floatingTexts.add(_FloatingText(
        id: id,
        text: '+${formatNumber(widget.coinsPerTap)}',
        icon: Icons.monetization_on,
        color: const Color(0xFFFFD600),
        offsetX: -40 + random.nextDouble() * 80,
        startY: -20,
      ));
      _floatingTexts.add(_FloatingText(
        id: id + 1000000,
        text: '+${formatNumber(widget.viewsPerTap)}',
        icon: Icons.visibility,
        color: const Color(0xFF2979FF),
        offsetX: -40 + random.nextDouble() * 80,
        startY: 0,
      ));
    });
    _nextId++;

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() {
          _floatingTexts.removeWhere(
            (f) => f.id == id || f.id == id + 1000000,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (final ft in _floatingTexts)
            _FloatingTextWidget(key: ValueKey(ft.id), data: ft),
          AnimatedBuilder(
            animation: _scaleAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              );
            },
            child: GestureDetector(
              onTap: _handleTap,
              child: Container(
                width: 180,
                height: 180,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      widget.color,
                      widget.color.withAlpha(180),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.color.withAlpha(80),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(widget.icon, size: 48, color: Colors.white),
                    const SizedBox(height: 8),
                    Text(
                      widget.label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingText {
  final int id;
  final String text;
  final IconData icon;
  final Color color;
  final double offsetX;
  final double startY;

  _FloatingText({
    required this.id,
    required this.text,
    required this.icon,
    required this.color,
    required this.offsetX,
    required this.startY,
  });
}

class _FloatingTextWidget extends StatefulWidget {
  final _FloatingText data;

  const _FloatingTextWidget({super.key, required this.data});

  @override
  State<_FloatingTextWidget> createState() => _FloatingTextWidgetState();
}

class _FloatingTextWidgetState extends State<_FloatingTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _moveAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _moveAnimation = Tween<double>(begin: 0, end: -100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(
            widget.data.offsetX,
            widget.data.startY + _moveAnimation.value,
          ),
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.data.icon, size: 16, color: widget.data.color),
                const SizedBox(width: 4),
                Text(
                  widget.data.text,
                  style: TextStyle(
                    color: widget.data.color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
