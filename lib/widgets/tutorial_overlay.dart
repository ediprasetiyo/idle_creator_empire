import 'package:flutter/material.dart';
import '../services/tutorial_service.dart';

class TutorialOverlay extends StatefulWidget {
  final TutorialService tutorialService;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const TutorialOverlay({
    super.key,
    required this.tutorialService,
    required this.onNext,
    required this.onSkip,
  });

  @override
  State<TutorialOverlay> createState() => _TutorialOverlayState();
}

class _TutorialOverlayState extends State<TutorialOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    )..forward();
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void didUpdateWidget(TutorialOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  IconData _getIcon() {
    switch (widget.tutorialService.stepIcon) {
      case 'touch_app':
        return Icons.touch_app;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'autorenew':
        return Icons.autorenew;
      case 'assignment':
        return Icons.assignment;
      case 'card_giftcard':
        return Icons.card_giftcard;
      case 'casino':
        return Icons.casino;
      case 'refresh':
        return Icons.refresh;
      case 'play_circle':
        return Icons.play_circle;
      case 'check_circle':
        return Icons.check_circle;
      default:
        return Icons.star;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tutorial = widget.tutorialService;
    final isLast = tutorial.currentStep == TutorialStep.complete;
    final progress = tutorial.stepIndex / tutorial.totalSteps;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.black.withAlpha(180),
        child: SafeArea(
          child: Center(
            child: SlideTransition(
              position: _slideAnimation,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A1A24),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF7C4DFF).withAlpha(60),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF7C4DFF).withAlpha(30),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: isLast
                              ? [const Color(0xFF00E676), const Color(0xFF00BFA5)]
                              : [const Color(0xFF7C4DFF), const Color(0xFFE040FB)],
                        ),
                      ),
                      child: Icon(_getIcon(), size: 32, color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      tutorial.stepTitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      tutorial.stepDescription,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white.withAlpha(180),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    if (!isLast) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 4,
                          backgroundColor: Colors.white.withAlpha(20),
                          valueColor: const AlwaysStoppedAnimation(Color(0xFF7C4DFF)),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${tutorial.stepIndex} / ${tutorial.totalSteps}',
                        style: TextStyle(
                          color: Colors.white.withAlpha(80),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                    Row(
                      children: [
                        if (!isLast)
                          Expanded(
                            child: TextButton(
                              onPressed: widget.onSkip,
                              child: Text(
                                'Skip Tutorial',
                                style: TextStyle(
                                  color: Colors.white.withAlpha(100),
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: FilledButton(
                            onPressed: widget.onNext,
                            style: FilledButton.styleFrom(
                              backgroundColor: isLast
                                  ? const Color(0xFF00E676)
                                  : const Color(0xFF7C4DFF),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            child: Text(
                              isLast ? 'Start Playing!' : 'Next',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
