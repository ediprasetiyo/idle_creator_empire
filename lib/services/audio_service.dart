class AudioService {
  bool _muted = false;

  bool get isMuted => _muted;

  void toggleMute() {
    _muted = !_muted;
  }

  void playTap() {
    if (_muted) return;
    _play('tap.wav');
  }

  void playBuy() {
    if (_muted) return;
    _play('buy.wav');
  }

  void playLevelUp() {
    if (_muted) return;
    _play('levelup.wav');
  }

  void playReward() {
    if (_muted) return;
    _play('reward.wav');
  }

  void playOffline() {
    if (_muted) return;
    _play('offline.wav');
  }

  void _play(String filename) {
    // Audio playback will be wired once assets/sounds/ contains the wav files.
    // Integration point: use audioplayers package with AssetSource('sounds/$filename')
  }

  void dispose() {
    // Dispose audio player resources when wired
  }
}
