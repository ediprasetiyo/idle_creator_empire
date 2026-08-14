import 'package:shared_preferences/shared_preferences.dart';

enum TutorialStep {
  welcome,
  tapToEarn,
  buyUpgrades,
  passiveIncome,
  missions,
  dailyReward,
  luckyWheel,
  prestige,
  watchAds,
  complete,
}

class TutorialService {
  static const String _keyCompleted = 'tutorial_completed';
  static const String _keyStep = 'tutorial_step';
  bool _completed = false;
  int _currentStepIndex = 0;

  bool get isCompleted => _completed;
  TutorialStep get currentStep =>
      _currentStepIndex < TutorialStep.values.length
          ? TutorialStep.values[_currentStepIndex]
          : TutorialStep.complete;
  bool get isActive => !_completed && _currentStepIndex < TutorialStep.values.length - 1;
  int get stepIndex => _currentStepIndex;
  int get totalSteps => TutorialStep.values.length - 1;

  Future<void> load(SharedPreferences prefs) async {
    _completed = prefs.getBool(_keyCompleted) ?? false;
    _currentStepIndex = prefs.getInt(_keyStep) ?? 0;
  }

  Future<void> advanceStep(SharedPreferences prefs) async {
    if (_completed) return;
    _currentStepIndex++;
    if (_currentStepIndex >= TutorialStep.values.length - 1) {
      _completed = true;
      await prefs.setBool(_keyCompleted, true);
    }
    await prefs.setInt(_keyStep, _currentStepIndex);
  }

  Future<void> skip(SharedPreferences prefs) async {
    _completed = true;
    _currentStepIndex = TutorialStep.values.length - 1;
    await prefs.setBool(_keyCompleted, true);
    await prefs.setInt(_keyStep, _currentStepIndex);
  }

  Future<void> reset(SharedPreferences prefs) async {
    _completed = false;
    _currentStepIndex = 0;
    await prefs.remove(_keyCompleted);
    await prefs.remove(_keyStep);
  }

  String get stepTitle {
    switch (currentStep) {
      case TutorialStep.welcome:
        return 'Welcome, Creator!';
      case TutorialStep.tapToEarn:
        return 'Tap to Create';
      case TutorialStep.buyUpgrades:
        return 'Upgrade Your Setup';
      case TutorialStep.passiveIncome:
        return 'Passive Income';
      case TutorialStep.missions:
        return 'Daily Missions';
      case TutorialStep.dailyReward:
        return 'Daily Rewards';
      case TutorialStep.luckyWheel:
        return 'Lucky Wheel';
      case TutorialStep.prestige:
        return 'Prestige System';
      case TutorialStep.watchAds:
        return 'Bonus Rewards';
      case TutorialStep.complete:
        return 'You\'re Ready!';
    }
  }

  String get stepDescription {
    switch (currentStep) {
      case TutorialStep.welcome:
        return 'Build your content creator empire from scratch! '
            'Start by creating content and watch your empire grow.';
      case TutorialStep.tapToEarn:
        return 'Tap the big button to create content. '
            'Each tap earns you coins, views, followers, and XP!';
      case TutorialStep.buyUpgrades:
        return 'Visit the Shop tab to buy upgrades. '
            'Better equipment means more coins per tap and auto income!';
      case TutorialStep.passiveIncome:
        return 'Some upgrades generate income automatically every second — '
            'even while you\'re away! Check back for offline earnings.';
      case TutorialStep.missions:
        return 'Complete daily missions for bonus coins and XP. '
            'New missions appear every day!';
      case TutorialStep.dailyReward:
        return 'Log in daily to claim increasing rewards. '
            'Build a 30-day streak for massive bonuses!';
      case TutorialStep.luckyWheel:
        return 'Spin the Lucky Wheel for free prizes! '
            'Win coins, XP, boosts, and even prestige points.';
      case TutorialStep.prestige:
        return 'When you\'re strong enough, prestige to reset and earn '
            'permanent multipliers. Each rebirth makes you stronger!';
      case TutorialStep.watchAds:
        return 'Watch short videos to earn 2x income boosts '
            'or bonus coins. Check the More tab for rewards!';
      case TutorialStep.complete:
        return 'You know the basics! Keep creating, upgrading, and '
            'growing your empire. Good luck, Creator!';
    }
  }

  String get stepIcon {
    switch (currentStep) {
      case TutorialStep.welcome:
        return 'star';
      case TutorialStep.tapToEarn:
        return 'touch_app';
      case TutorialStep.buyUpgrades:
        return 'shopping_bag';
      case TutorialStep.passiveIncome:
        return 'autorenew';
      case TutorialStep.missions:
        return 'assignment';
      case TutorialStep.dailyReward:
        return 'card_giftcard';
      case TutorialStep.luckyWheel:
        return 'casino';
      case TutorialStep.prestige:
        return 'refresh';
      case TutorialStep.watchAds:
        return 'play_circle';
      case TutorialStep.complete:
        return 'check_circle';
    }
  }
}
