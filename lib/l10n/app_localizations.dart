import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('id'),
  ];

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': _en,
    'id': _id,
  };

  String _t(String key) =>
      _localizedValues[locale.languageCode]?[key] ??
      _localizedValues['en']![key] ??
      key;

  // Navigation
  String get home => _t('home');
  String get shop => _t('shop');
  String get missions => _t('missions');
  String get achievements => _t('achievements');
  String get more => _t('more');
  String get settings => _t('settings');

  // Common
  String get next => _t('next');
  String get skip => _t('skip');
  String get close => _t('close');
  String get cancel => _t('cancel');
  String get confirm => _t('confirm');
  String get collect => _t('collect');
  String get ok => _t('ok');
  String get save => _t('save');
  String get delete => _t('delete');
  String get loading => _t('loading');
  String get error => _t('error');

  // Home
  String get createContent => _t('createContent');
  String get welcomeBack => _t('welcomeBack');
  String get perTap => _t('perTap');
  String get perSecond => _t('perSecond');
  String get prestigeBonus => _t('prestigeBonus');

  // Stats
  String get coins => _t('coins');
  String get views => _t('views');
  String get followers => _t('followers');
  String get level => _t('level');
  String get xp => _t('xp');
  String get rank => _t('rank');

  // Tutorial
  String get skipTutorial => _t('skipTutorial');
  String get startPlaying => _t('startPlaying');

  // Career
  String get chooseYourPath => _t('chooseYourPath');
  String get pickCareer => _t('pickCareer');
  String get startCreating => _t('startCreating');

  // Shop / Upgrades
  String get upgrades => _t('upgrades');
  String get buy => _t('buy');
  String get maxLevel => _t('maxLevel');
  String get locked => _t('locked');
  String get cost => _t('cost');

  // Missions
  String get dailyMissions => _t('dailyMissions');
  String get claim => _t('claim');
  String get completed => _t('completed');
  String get reward => _t('reward');
  String get newMissionsTomorrow => _t('newMissionsTomorrow');

  // Achievements
  String get achievementUnlocked => _t('achievementUnlocked');
  String get progress => _t('progress');

  // Prestige
  String get prestige => _t('prestige');
  String get prestigePoints => _t('prestigePoints');
  String get rebirth => _t('rebirth');
  String get prestigeWarning => _t('prestigeWarning');
  String get permanentBonuses => _t('permanentBonuses');

  // Daily Reward
  String get dailyReward => _t('dailyReward');
  String get dailyRewardAvailable => _t('dailyRewardAvailable');
  String get claimReward => _t('claimReward');
  String get streak => _t('streak');
  String get day => _t('day');
  String get later => _t('later');
  String get goClaim => _t('goClaim');

  // Lucky Wheel
  String get luckyWheel => _t('luckyWheel');
  String get spin => _t('spin');
  String get freeSpinAd => _t('freeSpinAd');
  String get cooldown => _t('cooldown');

  // Boosts
  String get boostActive => _t('boostActive');
  String get watchAd => _t('watchAd');
  String get doubleIncome => _t('doubleIncome');
  String get bonusCoins => _t('bonusCoins');

  // Settings
  String get soundEffects => _t('soundEffects');
  String get music => _t('music');
  String get hapticFeedback => _t('hapticFeedback');
  String get cloudSave => _t('cloudSave');
  String get syncToCloud => _t('syncToCloud');
  String get loadFromCloud => _t('loadFromCloud');
  String get restorePurchases => _t('restorePurchases');
  String get exportSave => _t('exportSave');
  String get importSave => _t('importSave');
  String get resetGame => _t('resetGame');
  String get credits => _t('credits');
  String get version => _t('version');
  String get audioHaptic => _t('audioHaptic');
  String get saveData => _t('saveData');
  String get about => _t('about');
  String get purchases => _t('purchases');

  // Legal
  String get privacyPolicy => _t('privacyPolicy');
  String get termsOfService => _t('termsOfService');
  String get dataDeletion => _t('dataDeletion');
  String get licenses => _t('licenses');

  // IAP
  String get premiumShop => _t('premiumShop');
  String get purchase => _t('purchase');
  String get restore => _t('restore');

  // Leaderboard
  String get leaderboard => _t('leaderboard');

  // Statistics
  String get statistics => _t('statistics');
  String get totalTaps => _t('totalTaps');
  String get totalCoinsEarned => _t('totalCoinsEarned');
  String get totalViewsEarned => _t('totalViewsEarned');
  String get totalUpgradesBought => _t('totalUpgradesBought');
  String get totalOnlineTime => _t('totalOnlineTime');
  String get highestCps => _t('highestCps');
  String get totalWheelSpins => _t('totalWheelSpins');

  // Offline
  String get whileYouWereAway => _t('whileYouWereAway');

  // Reset
  String get resetWarning => _t('resetWarning');
  String get deleteEverything => _t('deleteEverything');
  String get exportFirst => _t('exportFirst');

  // Cloud
  String get syncComplete => _t('syncComplete');
  String get syncFailed => _t('syncFailed');
  String get noCloudSave => _t('noCloudSave');
  String get cloudSaveLoaded => _t('cloudSaveLoaded');
  String get cloudLoadWarning => _t('cloudLoadWarning');

  // Misc
  String get initializing => _t('initializing');
  String get preparingEmpire => _t('preparingEmpire');
  String get levelUp => _t('levelUp');
  String get congratulations => _t('congratulations');

  // Careers
  String get careerGaming => _t('careerGaming');
  String get careerHorror => _t('careerHorror');
  String get careerFood => _t('careerFood');
  String get careerTravel => _t('careerTravel');
  String get careerComedy => _t('careerComedy');
  String get careerTechnology => _t('careerTechnology');
  String get careerEducation => _t('careerEducation');
  String get careerMusic => _t('careerMusic');

  static const Map<String, String> _en = {
    'home': 'Home',
    'shop': 'Shop',
    'missions': 'Missions',
    'achievements': 'Achieve',
    'more': 'More',
    'settings': 'Settings',
    'next': 'Next',
    'skip': 'Skip',
    'close': 'Close',
    'cancel': 'Cancel',
    'confirm': 'Confirm',
    'collect': 'Collect',
    'ok': 'OK',
    'save': 'Save',
    'delete': 'Delete',
    'loading': 'Loading...',
    'error': 'Error',
    'createContent': 'CREATE\nCONTENT',
    'welcomeBack': 'Welcome Back!',
    'perTap': 'per tap',
    'perSecond': '/s',
    'prestigeBonus': 'prestige bonus',
    'coins': 'Coins',
    'views': 'Views',
    'followers': 'Followers',
    'level': 'Level',
    'xp': 'XP',
    'rank': 'Rank',
    'skipTutorial': 'Skip Tutorial',
    'startPlaying': 'Start Playing!',
    'chooseYourPath': 'Choose Your Path',
    'pickCareer': 'Pick a creator career to begin your empire',
    'startCreating': 'Start Creating',
    'upgrades': 'Upgrades',
    'buy': 'Buy',
    'maxLevel': 'MAX',
    'locked': 'Locked',
    'cost': 'Cost',
    'dailyMissions': 'Daily Missions',
    'claim': 'Claim',
    'completed': 'Completed',
    'reward': 'Reward',
    'newMissionsTomorrow': 'New missions tomorrow!',
    'achievementUnlocked': 'Achievement Unlocked!',
    'progress': 'Progress',
    'prestige': 'Prestige',
    'prestigePoints': 'Prestige Points',
    'rebirth': 'Rebirth',
    'prestigeWarning': 'Reset your progress for permanent bonuses',
    'permanentBonuses': 'Permanent Bonuses',
    'dailyReward': 'Daily Reward',
    'dailyRewardAvailable': 'Daily Reward Available!',
    'claimReward': 'Claim Reward',
    'streak': 'Streak',
    'day': 'Day',
    'later': 'Later',
    'goClaim': 'Go Claim!',
    'luckyWheel': 'Lucky Wheel',
    'spin': 'SPIN',
    'freeSpinAd': 'Watch ad for free spin',
    'cooldown': 'Cooldown',
    'boostActive': 'Active',
    'watchAd': 'Watch Ad',
    'doubleIncome': '2x Income',
    'bonusCoins': 'Bonus Coins',
    'soundEffects': 'Sound Effects',
    'music': 'Music',
    'hapticFeedback': 'Haptic Feedback',
    'cloudSave': 'Cloud Save',
    'syncToCloud': 'Sync to Cloud',
    'loadFromCloud': 'Load from Cloud',
    'restorePurchases': 'Restore Purchases',
    'exportSave': 'Export Save',
    'importSave': 'Import Save',
    'resetGame': 'Reset Game',
    'credits': 'Credits',
    'version': 'Version',
    'audioHaptic': 'Audio & Haptic',
    'saveData': 'Save Data',
    'about': 'About',
    'purchases': 'Purchases',
    'privacyPolicy': 'Privacy Policy',
    'termsOfService': 'Terms of Service',
    'dataDeletion': 'Data Deletion',
    'licenses': 'Licenses',
    'premiumShop': 'Premium Shop',
    'purchase': 'Purchase',
    'restore': 'Restore',
    'leaderboard': 'Leaderboard',
    'statistics': 'Statistics',
    'totalTaps': 'Total Taps',
    'totalCoinsEarned': 'Total Coins Earned',
    'totalViewsEarned': 'Total Views Earned',
    'totalUpgradesBought': 'Total Upgrades Bought',
    'totalOnlineTime': 'Total Online Time',
    'highestCps': 'Highest Coins/s',
    'totalWheelSpins': 'Total Wheel Spins',
    'whileYouWereAway': 'While you were away:',
    'resetWarning':
        'This will permanently delete ALL your progress. This cannot be undone!',
    'deleteEverything': 'Delete Everything',
    'exportFirst': 'Consider exporting your save first.',
    'syncComplete': 'Save synced to cloud!',
    'syncFailed': 'Sync failed',
    'noCloudSave': 'No cloud save found.',
    'cloudSaveLoaded': 'Cloud save loaded!',
    'cloudLoadWarning':
        'This will replace your current local save with the cloud save. '
            'Any local progress not synced will be lost.',
    'initializing': 'Initializing...',
    'preparingEmpire': 'Preparing your empire...',
    'levelUp': 'Level Up!',
    'congratulations': 'Congratulations!',
    'careerGaming': 'Gaming',
    'careerHorror': 'Horror',
    'careerFood': 'Food',
    'careerTravel': 'Travel',
    'careerComedy': 'Comedy',
    'careerTechnology': 'Technology',
    'careerEducation': 'Education',
    'careerMusic': 'Music',
  };

  static const Map<String, String> _id = {
    'home': 'Beranda',
    'shop': 'Toko',
    'missions': 'Misi',
    'achievements': 'Prestasi',
    'more': 'Lainnya',
    'settings': 'Pengaturan',
    'next': 'Lanjut',
    'skip': 'Lewati',
    'close': 'Tutup',
    'cancel': 'Batal',
    'confirm': 'Konfirmasi',
    'collect': 'Kumpulkan',
    'ok': 'OK',
    'save': 'Simpan',
    'delete': 'Hapus',
    'loading': 'Memuat...',
    'error': 'Kesalahan',
    'createContent': 'BUAT\nKONTEN',
    'welcomeBack': 'Selamat Datang Kembali!',
    'perTap': 'per ketuk',
    'perSecond': '/dtk',
    'prestigeBonus': 'bonus prestise',
    'coins': 'Koin',
    'views': 'Tayangan',
    'followers': 'Pengikut',
    'level': 'Level',
    'xp': 'XP',
    'rank': 'Peringkat',
    'skipTutorial': 'Lewati Tutorial',
    'startPlaying': 'Mulai Main!',
    'chooseYourPath': 'Pilih Jalurmu',
    'pickCareer': 'Pilih karir kreator untuk memulai kerajaanmu',
    'startCreating': 'Mulai Berkreasi',
    'upgrades': 'Peningkatan',
    'buy': 'Beli',
    'maxLevel': 'MAKS',
    'locked': 'Terkunci',
    'cost': 'Harga',
    'dailyMissions': 'Misi Harian',
    'claim': 'Klaim',
    'completed': 'Selesai',
    'reward': 'Hadiah',
    'newMissionsTomorrow': 'Misi baru besok!',
    'achievementUnlocked': 'Pencapaian Terbuka!',
    'progress': 'Kemajuan',
    'prestige': 'Prestise',
    'prestigePoints': 'Poin Prestise',
    'rebirth': 'Kelahiran Kembali',
    'prestigeWarning': 'Reset kemajuanmu untuk bonus permanen',
    'permanentBonuses': 'Bonus Permanen',
    'dailyReward': 'Hadiah Harian',
    'dailyRewardAvailable': 'Hadiah Harian Tersedia!',
    'claimReward': 'Klaim Hadiah',
    'streak': 'Beruntun',
    'day': 'Hari',
    'later': 'Nanti',
    'goClaim': 'Klaim Sekarang!',
    'luckyWheel': 'Roda Keberuntungan',
    'spin': 'PUTAR',
    'freeSpinAd': 'Tonton iklan untuk putaran gratis',
    'cooldown': 'Jeda',
    'boostActive': 'Aktif',
    'watchAd': 'Tonton Iklan',
    'doubleIncome': '2x Pendapatan',
    'bonusCoins': 'Bonus Koin',
    'soundEffects': 'Efek Suara',
    'music': 'Musik',
    'hapticFeedback': 'Umpan Balik Getar',
    'cloudSave': 'Simpan Cloud',
    'syncToCloud': 'Sinkron ke Cloud',
    'loadFromCloud': 'Muat dari Cloud',
    'restorePurchases': 'Pulihkan Pembelian',
    'exportSave': 'Ekspor Simpanan',
    'importSave': 'Impor Simpanan',
    'resetGame': 'Reset Permainan',
    'credits': 'Kredit',
    'version': 'Versi',
    'audioHaptic': 'Audio & Getar',
    'saveData': 'Data Simpanan',
    'about': 'Tentang',
    'purchases': 'Pembelian',
    'privacyPolicy': 'Kebijakan Privasi',
    'termsOfService': 'Ketentuan Layanan',
    'dataDeletion': 'Penghapusan Data',
    'licenses': 'Lisensi',
    'premiumShop': 'Toko Premium',
    'purchase': 'Beli',
    'restore': 'Pulihkan',
    'leaderboard': 'Papan Peringkat',
    'statistics': 'Statistik',
    'totalTaps': 'Total Ketukan',
    'totalCoinsEarned': 'Total Koin Diperoleh',
    'totalViewsEarned': 'Total Tayangan Diperoleh',
    'totalUpgradesBought': 'Total Peningkatan Dibeli',
    'totalOnlineTime': 'Total Waktu Online',
    'highestCps': 'Koin/dtk Tertinggi',
    'totalWheelSpins': 'Total Putaran Roda',
    'whileYouWereAway': 'Selama kamu pergi:',
    'resetWarning':
        'Ini akan menghapus SEMUA kemajuanmu secara permanen. Tidak bisa dibatalkan!',
    'deleteEverything': 'Hapus Semua',
    'exportFirst': 'Pertimbangkan untuk mengekspor simpanan terlebih dahulu.',
    'syncComplete': 'Simpanan disinkronkan ke cloud!',
    'syncFailed': 'Sinkronisasi gagal',
    'noCloudSave': 'Tidak ada simpanan cloud.',
    'cloudSaveLoaded': 'Simpanan cloud dimuat!',
    'cloudLoadWarning':
        'Ini akan mengganti simpanan lokal dengan simpanan cloud. '
            'Kemajuan lokal yang belum disinkronkan akan hilang.',
    'initializing': 'Menginisialisasi...',
    'preparingEmpire': 'Menyiapkan kerajaanmu...',
    'levelUp': 'Naik Level!',
    'congratulations': 'Selamat!',
    'careerGaming': 'Gaming',
    'careerHorror': 'Horor',
    'careerFood': 'Kuliner',
    'careerTravel': 'Traveling',
    'careerComedy': 'Komedi',
    'careerTechnology': 'Teknologi',
    'careerEducation': 'Edukasi',
    'careerMusic': 'Musik',
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales
          .map((l) => l.languageCode)
          .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
