import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/wheel_reward.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';
import '../widgets/wheel_widget.dart';

class WheelScreen extends StatefulWidget {
  const WheelScreen({super.key});

  @override
  State<WheelScreen> createState() => _WheelScreenState();
}

class _WheelScreenState extends State<WheelScreen> {
  bool _spinning = false;
  int _targetIndex = 0;
  String? _resultText;

  void _spin(GameProvider gp) {
    if (_spinning) return;
    if (!gp.player!.canSpinWheel) return;

    final index = gp.determineWheelResult();
    setState(() {
      _spinning = true;
      _targetIndex = index;
      _resultText = null;
    });
    gp.audioService.playWheelSpin();
  }

  void _onSpinComplete(GameProvider gp) {
    final segment = allWheelSegments[_targetIndex];
    gp.claimWheelReward(_targetIndex);
    setState(() {
      _spinning = false;
      _resultText = 'You won: ${segment.label}!';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final player = gp.player;
        if (player == null) return const SizedBox.shrink();

        final canSpin = player.canSpinWheel && !_spinning;
        final cooldownMs = player.wheelCooldownRemaining;
        final career = player.career;

        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Lucky Wheel',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
          ),
          body: Column(
            children: [
              const Spacer(),
              Center(
                child: WheelWidget(
                  targetIndex: _targetIndex,
                  spinning: _spinning,
                  onSpinComplete: () => _onSpinComplete(gp),
                ),
              ),
              const SizedBox(height: 20),
              if (_resultText != null)
                AnimatedOpacity(
                  opacity: _resultText != null ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFD600).withAlpha(20),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFFD600).withAlpha(40)),
                    ),
                    child: Text(
                      _resultText!,
                      style: const TextStyle(
                        color: Color(0xFFFFD600),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: canSpin ? () => _spin(gp) : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: career.color,
                      disabledBackgroundColor: const Color(0xFF1A1A24),
                      disabledForegroundColor: Colors.white.withAlpha(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: _spinning
                        ? const Text(
                            'Spinning...',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                          )
                        : canSpin
                            ? const Text(
                                'SPIN!',
                                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                              )
                            : Text(
                                'Next spin in ${formatCountdown(cooldownMs)}',
                                style: const TextStyle(fontSize: 14),
                              ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton.icon(
                onPressed: !canSpin && !_spinning
                    ? () => gp.watchAdForWheelSpin()
                    : null,
                icon: const Icon(Icons.play_circle_outline, size: 18),
                label: const Text('Watch Ad for Free Spin'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF2979FF),
                  disabledForegroundColor: Colors.white.withAlpha(30),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text(
                  'Total spins: ${player.totalWheelSpins}',
                  style: TextStyle(color: Colors.white.withAlpha(60), fontSize: 11),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
