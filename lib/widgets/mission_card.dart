import 'package:flutter/material.dart';
import '../models/mission.dart';
import '../utils/formatters.dart';

class MissionCard extends StatelessWidget {
  final Mission mission;
  final double progress;
  final bool isComplete;
  final bool isClaimed;
  final VoidCallback onClaim;

  const MissionCard({
    super.key,
    required this.mission,
    required this.progress,
    required this.isComplete,
    required this.isClaimed,
    required this.onClaim,
  });

  @override
  Widget build(BuildContext context) {
    final color = mission.type.color;
    final progressClamped = progress.clamp(0.0, 1.0);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(16),
        border: isComplete && !isClaimed
            ? Border.all(color: color.withAlpha(80), width: 1.5)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isClaimed
                        ? const Color(0xFF00E676).withAlpha(20)
                        : color.withAlpha(30),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isClaimed ? Icons.check_circle : mission.type.icon,
                    color: isClaimed ? const Color(0xFF00E676) : color,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mission.name,
                        style: TextStyle(
                          color: isClaimed
                              ? Colors.white.withAlpha(100)
                              : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          decoration:
                              isClaimed ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.monetization_on,
                            size: 12,
                            color: const Color(0xFFFFD600).withAlpha(180),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            formatNumber(mission.coinReward),
                            style: TextStyle(
                              color: const Color(0xFFFFD600).withAlpha(180),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Icon(
                            Icons.auto_awesome,
                            size: 12,
                            color: const Color(0xFF7C4DFF).withAlpha(180),
                          ),
                          const SizedBox(width: 3),
                          Text(
                            '${formatNumber(mission.xpReward)} XP',
                            style: TextStyle(
                              color: const Color(0xFF7C4DFF).withAlpha(180),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (isComplete && !isClaimed)
                  _ClaimButton(color: color, onClaim: onClaim),
                if (isClaimed)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00E676).withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Done',
                      style: TextStyle(
                        color: Color(0xFF00E676),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            if (!isClaimed) ...[
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progressClamped,
                  minHeight: 6,
                  backgroundColor: Colors.white.withAlpha(15),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isComplete ? const Color(0xFF00E676) : color,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  '${(progressClamped * 100).toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: Colors.white.withAlpha(80),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ClaimButton extends StatefulWidget {
  final Color color;
  final VoidCallback onClaim;

  const _ClaimButton({required this.color, required this.onClaim});

  @override
  State<_ClaimButton> createState() => _ClaimButtonState();
}

class _ClaimButtonState extends State<_ClaimButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);
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
        return Transform.scale(
          scale: 1.0 + _controller.value * 0.08,
          child: child,
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onClaim,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: widget.color.withAlpha(60),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Text(
              'Claim',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
