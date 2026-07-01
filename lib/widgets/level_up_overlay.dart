import 'package:flutter/material.dart';
import '../models/player.dart';

class LevelUpOverlay extends StatefulWidget {
  final int newLevel;
  final Color accentColor;
  final VoidCallback onDismiss;

  const LevelUpOverlay({
    super.key,
    required this.newLevel,
    required this.accentColor,
    required this.onDismiss,
  });

  @override
  State<LevelUpOverlay> createState() => _LevelUpOverlayState();
}

class _LevelUpOverlayState extends State<LevelUpOverlay>
    with TickerProviderStateMixin {
  late AnimationController _bgController;
  late AnimationController _contentController;
  late Animation<double> _bgOpacity;
  late Animation<double> _scale;
  late Animation<double> _contentOpacity;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _contentController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _bgOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _bgController, curve: Curves.easeIn),
    );
    _scale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.7, curve: Curves.elasticOut),
      ),
    );
    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeInOut),
      ),
    );

    _bgController.forward();
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) _contentController.forward();
    });

    Future.delayed(const Duration(seconds: 3), () {
      _dismiss();
    });
  }

  void _dismiss() {
    if (!mounted) return;
    _contentController.reverse();
    _bgController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String _rankForLevel(int level) {
    if (level >= 50) return ranks[9];
    if (level >= 40) return ranks[8];
    if (level >= 35) return ranks[7];
    if (level >= 30) return ranks[6];
    if (level >= 25) return ranks[5];
    if (level >= 20) return ranks[4];
    if (level >= 15) return ranks[3];
    if (level >= 10) return ranks[2];
    if (level >= 5) return ranks[1];
    return ranks[0];
  }

  @override
  Widget build(BuildContext context) {
    final rank = _rankForLevel(widget.newLevel);

    return GestureDetector(
      onTap: _dismiss,
      child: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            color: Colors.black.withAlpha((_bgOpacity.value * 180).toInt()),
            child: child,
          );
        },
        child: Center(
          child: AnimatedBuilder(
            animation: _contentController,
            builder: (context, child) {
              return Opacity(
                opacity: _contentOpacity.value,
                child: Transform.scale(
                  scale: _scale.value,
                  child: child,
                ),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedBuilder(
                  animation: _glowAnimation,
                  builder: (context, child) {
                    return Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            widget.accentColor.withAlpha(
                              (60 + _glowAnimation.value * 40).toInt(),
                            ),
                            widget.accentColor.withAlpha(10),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: widget.accentColor.withAlpha(
                              (40 + _glowAnimation.value * 40).toInt(),
                            ),
                            blurRadius: 40 + _glowAnimation.value * 20,
                            spreadRadius: _glowAnimation.value * 10,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          '${widget.newLevel}',
                          style: TextStyle(
                            color: widget.accentColor,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'LEVEL UP!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: widget.accentColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    rank,
                    style: TextStyle(
                      color: widget.accentColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Tap to continue',
                  style: TextStyle(
                    color: Colors.white.withAlpha(80),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
