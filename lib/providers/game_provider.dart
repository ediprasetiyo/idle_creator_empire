import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/career.dart';
import '../models/player.dart';
import '../models/upgrade.dart';
import '../services/save_service.dart';
import '../utils/constants.dart';

class OfflineEarnings {
  final double coins;
  final double views;
  final double followers;
  final Duration duration;

  const OfflineEarnings({
    required this.coins,
    required this.views,
    required this.followers,
    required this.duration,
  });

  bool get hasEarnings => coins > 0 || views > 0 || followers > 0;
}

class GameProvider extends ChangeNotifier {
  final SaveService _saveService;
  Player? _player;
  bool _isLoaded = false;
  OfflineEarnings? _offlineEarnings;
  Timer? _autoIncomeTimer;
  int _saveCounter = 0;

  GameProvider(this._saveService);

  Player? get player => _player;
  bool get isLoaded => _isLoaded;
  bool get hasPlayer => _player != null;
  OfflineEarnings? get offlineEarnings => _offlineEarnings;

  Future<void> load() async {
    await _saveService.init();
    _player = _saveService.loadPlayer();
    if (_player != null) {
      _calculateOfflineEarnings();
      _startAutoIncome();
    }
    _isLoaded = true;
    notifyListeners();
  }

  void clearOfflineEarnings() {
    _offlineEarnings = null;
  }

  void _calculateOfflineEarnings() {
    final lastSave = _saveService.loadLastSaveTimestamp();
    if (lastSave == null || _player == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final elapsedMs = now - lastSave;
    if (elapsedMs < 60000) return;

    final maxMs = GameConstants.maxOfflineHours * 3600 * 1000;
    final cappedMs = elapsedMs > maxMs ? maxMs : elapsedMs;
    final seconds = cappedMs / 1000.0;

    final p = _player!;
    final coins = p.coinsPerSecond * seconds;
    final views = p.viewsPerSecond * seconds;
    final followers = p.followersPerSecond * seconds;

    if (coins > 0 || views > 0 || followers > 0) {
      p.coins += coins;
      p.views += views;
      p.followers += followers;
      _offlineEarnings = OfflineEarnings(
        coins: coins,
        views: views,
        followers: followers,
        duration: Duration(milliseconds: cappedMs),
      );
      _saveService.savePlayer(p);
    }
  }

  Future<void> selectCareer(Career career) async {
    _player = Player(career: career);
    await _saveService.saveCareer(career);
    await _saveService.savePlayer(_player!);
    _startAutoIncome();
    notifyListeners();
  }

  void tap() {
    if (_player == null) return;
    final p = _player!;

    p.coins += p.coinsPerTap;
    p.views += p.viewsPerTap;
    p.followers += p.followersPerTap;
    p.xp += p.xpPerTap;

    while (p.xp >= p.xpToNextLevel) {
      p.xp -= p.xpToNextLevel;
      p.level++;
    }

    _saveCounter++;
    if (_saveCounter >= 5) {
      _saveCounter = 0;
      _saveService.savePlayer(p);
    }
    notifyListeners();
  }

  bool canBuyUpgrade(Upgrade upgrade) {
    if (_player == null) return false;
    final level = _player!.upgradeLevel(upgrade.type);
    return _player!.coins >= upgrade.costForLevel(level);
  }

  void buyUpgrade(Upgrade upgrade) {
    if (_player == null) return;
    final p = _player!;
    final level = p.upgradeLevel(upgrade.type);
    final cost = upgrade.costForLevel(level);
    if (p.coins < cost) return;

    p.coins -= cost;
    p.upgradeLevels[upgrade.type] = level + 1;
    _saveService.savePlayer(p);
    notifyListeners();
  }

  void _startAutoIncome() {
    _autoIncomeTimer?.cancel();
    _autoIncomeTimer = Timer.periodic(
      const Duration(milliseconds: GameConstants.autoIncomeIntervalMs),
      (_) => _tickAutoIncome(),
    );
  }

  void _tickAutoIncome() {
    if (_player == null || !_player!.hasAutoIncome) return;
    final p = _player!;

    p.coins += p.coinsPerSecond;
    p.views += p.viewsPerSecond;
    p.followers += p.followersPerSecond;

    _saveCounter++;
    if (_saveCounter >= 10) {
      _saveCounter = 0;
      _saveService.savePlayer(p);
    }
    notifyListeners();
  }

  @override
  void dispose() {
    _autoIncomeTimer?.cancel();
    if (_player != null) {
      _saveService.savePlayer(_player!);
    }
    super.dispose();
  }
}
