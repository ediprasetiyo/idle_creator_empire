import 'package:flutter/material.dart';
import '../utils/formatters.dart';

class CoinCounter extends StatelessWidget {
  final double coins;

  const CoinCounter({super.key, required this.coins});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.monetization_on,
            color: Color(0xFFFFD600),
            size: 20,
          ),
          const SizedBox(width: 6),
          Text(
            formatNumber(coins),
            style: const TextStyle(
              color: Color(0xFFFFD600),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
