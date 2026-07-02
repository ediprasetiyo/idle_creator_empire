class AudioService {
  bool _soundMuted = false;
  bool _musicMuted = false;

  bool get isSoundMuted => _soundMuted;
  bool get isMusicMuted => _musicMuted;
  bool get isMuted => _soundMuted;

  void toggleSound() {
    _soundMuted = !_soundMuted;
  }

  void toggleMusic() {
    _musicMuted = !_musicMuted;
    if (_musicMuted) {
      _stopMusic();
    } else {
      _startMusic();
    }
  }

  void toggleMute() {
    toggleSound();
  }

  void playTap() {
    if (_soundMuted) return;
    _play('tap.wav');
  }

  void playBuy() {
    if (_soundMuted) return;
    _play('buy.wav');
  }

  void playLevelUp() {
    if (_soundMuted) return;
    _play('levelup.wav');
  }

  void playReward() {
    if (_soundMuted) return;
    _play('reward.wav');
  }

  void playOffline() {
    if (_soundMuted) return;
    _play('offline.wav');
  }

  void playPrestige() {
    if (_soundMuted) return;
    _play('prestige.wav');
  }

  void playWheelSpin() {
    if (_soundMuted) return;
    _play('wheel.wav');
  }

  void playWheelResult() {
    if (_soundMuted) return;
    _play('wheel_result.wav');
  }

  void playBoost() {
    if (_soundMuted) return;
    _play('boost.wav');
  }

  void _play(String filename) {
    // Integration point: use audioplayers package
    // final player = AudioPlayer();
    // player.play(AssetSource('sounds/$filename'));
  }

  void _startMusic() {
    // Integration point: start background music loop
    // _musicPlayer.play(AssetSource('music/bg.mp3'));
    // _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void _stopMusic() {
    // Integration point: stop background music
    // _musicPlayer.stop();
  }

  void dispose() {
    // Dispose audio player resources when wired
  }
}
