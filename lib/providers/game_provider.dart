import 'package:flutter/foundation.dart';
import '../models/career.dart';
import '../models/player.dart';
import '../services/save_service.dart';

class GameProvider extends ChangeNotifier {
  final SaveService _saveService;
  Player? _player;
  bool _isLoaded = false;

  GameProvider(this._saveService);

  Player? get player => _player;
  bool get isLoaded => _isLoaded;
  bool get hasPlayer => _player != null;

  Future<void> load() async {
    await _saveService.init();
    _player = _saveService.loadPlayer();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> selectCareer(Career career) async {
    _player = Player(career: career);
    await _saveService.saveCareer(career);
    await _saveService.savePlayer(_player!);
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

    _saveService.savePlayer(p);
    notifyListeners();
  }
}
