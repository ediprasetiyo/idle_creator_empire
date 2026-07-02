import 'dart:async';
import '../models/leaderboard_entry.dart';

class LeaderboardService {
  bool _initialized = false;
  final Map<LeaderboardType, List<LeaderboardEntry>> _cache = {};
  int _lastRefresh = 0;
  static const int _cacheLifetimeMs = 300000;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    // Integration point: connect to leaderboard backend
    // (Firebase Firestore, custom REST API, or Google Play Games Leaderboards)
    _initialized = true;
  }

  Future<List<LeaderboardEntry>> getLeaderboard(
    LeaderboardType type, {
    int limit = 50,
    bool forceRefresh = false,
  }) async {
    if (!_initialized) return [];

    final now = DateTime.now().millisecondsSinceEpoch;
    if (!forceRefresh &&
        _cache.containsKey(type) &&
        now - _lastRefresh < _cacheLifetimeMs) {
      return _cache[type]!;
    }

    // Integration point: fetch from backend
    // try {
    //   final snapshot = await _firestore
    //       .collection('leaderboard_${type.key}')
    //       .orderBy('value', descending: true)
    //       .limit(limit)
    //       .get();
    //   final entries = snapshot.docs.asMap().entries.map((e) {
    //     return LeaderboardEntry.fromMap(e.value.data())
    //       ..rank = e.key + 1;
    //   }).toList();
    //   _cache[type] = entries;
    //   _lastRefresh = now;
    //   return entries;
    // } catch (e) {
    //   return _cache[type] ?? [];
    // }

    _cache[type] = _generateSampleEntries(type, limit);
    _lastRefresh = now;
    return _cache[type]!;
  }

  Future<void> submitScore({
    required LeaderboardType type,
    required String playerId,
    required String displayName,
    required double value,
    required String career,
    required int prestigeCount,
  }) async {
    if (!_initialized) return;

    // Integration point: submit to backend
    // try {
    //   await _firestore.collection('leaderboard_${type.key}').doc(playerId).set({
    //     'playerId': playerId,
    //     'displayName': displayName,
    //     'value': value,
    //     'career': career,
    //     'prestigeCount': prestigeCount,
    //     'updatedAt': FieldValue.serverTimestamp(),
    //   });
    // } catch (_) {}
  }

  Future<int?> getPlayerRank(LeaderboardType type, String playerId) async {
    final entries = await getLeaderboard(type);
    for (int i = 0; i < entries.length; i++) {
      if (entries[i].playerId == playerId) return i + 1;
    }
    return null;
  }

  List<LeaderboardEntry> _generateSampleEntries(LeaderboardType type, int limit) {
    final careers = ['gaming', 'horror', 'food', 'travel', 'comedy', 'technology', 'education', 'music'];
    final names = ['ProGamer42', 'CreatorX', 'StarMaker', 'EmpireKing', 'ContentQueen',
      'ViewMaster', 'CoinCollector', 'PrestigeHero', 'TapChamp', 'IdleLord'];

    return List.generate(limit > 10 ? 10 : limit, (i) {
      final baseValue = type == LeaderboardType.topPrestige
          ? (10 - i) * 5.0
          : type == LeaderboardType.topIncome
              ? (10 - i) * 500.0
              : (10 - i) * 50000.0;
      return LeaderboardEntry(
        playerId: 'sample_$i',
        displayName: i < names.length ? names[i] : 'Player${i + 1}',
        rank: i + 1,
        value: baseValue,
        career: careers[i % careers.length],
        prestigeCount: (10 - i).clamp(0, 10),
      );
    });
  }

  void clearCache() {
    _cache.clear();
    _lastRefresh = 0;
  }
}
