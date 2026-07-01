import 'package:flutter/material.dart';

enum Career {
  gaming(
    label: 'Gaming',
    icon: Icons.sports_esports,
    color: Color(0xFF7C4DFF),
    contentVerb: 'Stream',
  ),
  horror(
    label: 'Horror',
    icon: Icons.visibility,
    color: Color(0xFFFF1744),
    contentVerb: 'Haunt',
  ),
  food(
    label: 'Food',
    icon: Icons.restaurant,
    color: Color(0xFFFF9100),
    contentVerb: 'Cook',
  ),
  travel(
    label: 'Travel',
    icon: Icons.flight,
    color: Color(0xFF00BFA5),
    contentVerb: 'Explore',
  ),
  comedy(
    label: 'Comedy',
    icon: Icons.emoji_emotions,
    color: Color(0xFFFFD600),
    contentVerb: 'Perform',
  ),
  technology(
    label: 'Technology',
    icon: Icons.computer,
    color: Color(0xFF2979FF),
    contentVerb: 'Build',
  ),
  education(
    label: 'Education',
    icon: Icons.school,
    color: Color(0xFF00E676),
    contentVerb: 'Teach',
  ),
  music(
    label: 'Music',
    icon: Icons.music_note,
    color: Color(0xFFE040FB),
    contentVerb: 'Compose',
  );

  const Career({
    required this.label,
    required this.icon,
    required this.color,
    required this.contentVerb,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String contentVerb;
}
