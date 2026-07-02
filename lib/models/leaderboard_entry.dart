class LeaderboardEntry {
  final String playerId;
  final String displayName;
  final int rank;
  final double value;
  final String career;
  final int prestigeCount;

  const LeaderboardEntry({
    required this.playerId,
    required this.displayName,
    required this.rank,
    required this.value,
    required this.career,
    required this.prestigeCount,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      playerId: map['playerId'] as String? ?? '',
      displayName: map['displayName'] as String? ?? 'Player',
      rank: map['rank'] as int? ?? 0,
      value: (map['value'] as num?)?.toDouble() ?? 0,
      career: map['career'] as String? ?? '',
      prestigeCount: map['prestigeCount'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'playerId': playerId,
      'displayName': displayName,
      'rank': rank,
      'value': value,
      'career': career,
      'prestigeCount': prestigeCount,
    };
  }
}

enum LeaderboardType {
  topCoins('Top Coins', 'coins'),
  topPrestige('Top Prestige', 'prestige'),
  topIncome('Top Income/sec', 'income'),
  friends('Friends', 'friends'),
  global('Global', 'global');

  final String label;
  final String key;
  const LeaderboardType(this.label, this.key);
}
