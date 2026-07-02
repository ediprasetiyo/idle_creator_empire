import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/career.dart';
import '../providers/game_provider.dart';
import 'home_screen.dart';

class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
  Career? _selected;

  void _confirm() async {
    if (_selected == null) return;

    final gameProvider = context.read<GameProvider>();
    await gameProvider.selectCareer(_selected!);

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text(
                'Choose Your Path',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Pick a creator career to begin your empire',
                style: TextStyle(
                  color: Colors.white.withAlpha(120),
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.3,
                  ),
                  itemCount: Career.values.length,
                  itemBuilder: (context, index) {
                    final career = Career.values[index];
                    final isSelected = _selected == career;
                    return _CareerCard(
                      career: career,
                      isSelected: isSelected,
                      onTap: () => setState(() => _selected = career),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: FilledButton(
                  onPressed: _selected != null ? _confirm : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: _selected?.color ?? Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Start Creating',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _CareerCard extends StatelessWidget {
  final Career career;
  final bool isSelected;
  final VoidCallback onTap;

  const _CareerCard({
    required this.career,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? career.color.withAlpha(40)
              : const Color(0xFF1A1A24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? career.color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              career.icon,
              size: 36,
              color: isSelected ? career.color : Colors.white.withAlpha(180),
            ),
            const SizedBox(height: 8),
            Text(
              career.label,
              style: TextStyle(
                color: isSelected ? career.color : Colors.white.withAlpha(180),
                fontSize: 14,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
