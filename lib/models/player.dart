import 'career.dart';

class Player {
  Career career;
  double coins;
  double views;
  double followers;
  double xp;
  int level;

  Player({
    required this.career,
    this.coins = 0,
    this.views = 0,
    this.followers = 0,
    this.xp = 0,
    this.level = 1,
  });

  double get xpToNextLevel => 100.0 * level * 1.5;

  double get xpProgress => (xp / xpToNextLevel).clamp(0.0, 1.0);

  double get coinsPerTap => 1.0 + (level * 0.5);

  double get viewsPerTap => 5.0 + (level * 2.0);

  double get followersPerTap => 0.2 + (level * 0.1);

  double get xpPerTap => 10.0 + (level * 1.0);

  String get title {
    if (level >= 50) return 'Legend';
    if (level >= 40) return 'Superstar';
    if (level >= 30) return 'Celebrity';
    if (level >= 20) return 'Influencer';
    if (level >= 15) return 'Creator';
    if (level >= 10) return 'Rising Star';
    if (level >= 5) return 'Amateur';
    return 'Beginner';
  }
}
