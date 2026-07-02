import 'dart:async';
import '../config/analytics_events.dart';

class RemoteConfigService {
  bool _initialized = false;
  final Map<String, dynamic> _values = {};

  bool get isInitialized => _initialized;

  final Map<String, dynamic> _defaults = {
    AnalyticsEvents.remoteKeyWheelCooldownHours: 4,
    AnalyticsEvents.remoteKeyAdFrequencyCap: 3,
    AnalyticsEvents.remoteKeyPrestigeMultiplierBase: 0.1,
    AnalyticsEvents.remoteKeyMaxOfflineHours: 8,
    AnalyticsEvents.remoteKeyMaintenanceMode: false,
    AnalyticsEvents.remoteKeyForceUpdate: false,
    AnalyticsEvents.remoteKeyLatestVersion: '1.2.0',
  };

  Future<void> initialize() async {
    // Integration point: Firebase Remote Config
    // final remoteConfig = FirebaseRemoteConfig.instance;
    // await remoteConfig.setConfigSettings(RemoteConfigSettings(
    //   fetchTimeout: const Duration(minutes: 1),
    //   minimumFetchInterval: const Duration(hours: 1),
    // ));
    // await remoteConfig.setDefaults(_defaults.map((k, v) => MapEntry(k, v)));
    // try {
    //   await remoteConfig.fetchAndActivate();
    // } catch (_) {}
    // _loadValues(remoteConfig);

    _values.addAll(_defaults);
    _initialized = true;
  }

  // void _loadValues(FirebaseRemoteConfig config) {
  //   for (final key in _defaults.keys) {
  //     final defaultVal = _defaults[key];
  //     if (defaultVal is int) {
  //       _values[key] = config.getInt(key);
  //     } else if (defaultVal is double) {
  //       _values[key] = config.getDouble(key);
  //     } else if (defaultVal is bool) {
  //       _values[key] = config.getBool(key);
  //     } else if (defaultVal is String) {
  //       _values[key] = config.getString(key);
  //     }
  //   }
  // }

  int getInt(String key) => _values[key] as int? ?? _defaults[key] as int? ?? 0;
  double getDouble(String key) => _values[key] as double? ?? _defaults[key] as double? ?? 0.0;
  bool getBool(String key) => _values[key] as bool? ?? _defaults[key] as bool? ?? false;
  String getString(String key) => _values[key] as String? ?? _defaults[key] as String? ?? '';

  int get wheelCooldownHours => getInt(AnalyticsEvents.remoteKeyWheelCooldownHours);
  int get adFrequencyCap => getInt(AnalyticsEvents.remoteKeyAdFrequencyCap);
  double get prestigeMultiplierBase => getDouble(AnalyticsEvents.remoteKeyPrestigeMultiplierBase);
  int get maxOfflineHours => getInt(AnalyticsEvents.remoteKeyMaxOfflineHours);
  bool get maintenanceMode => getBool(AnalyticsEvents.remoteKeyMaintenanceMode);
  bool get forceUpdate => getBool(AnalyticsEvents.remoteKeyForceUpdate);
  String get latestVersion => getString(AnalyticsEvents.remoteKeyLatestVersion);

  Future<void> refresh() async {
    if (!_initialized) return;
    // Integration point:
    // try {
    //   await FirebaseRemoteConfig.instance.fetchAndActivate();
    //   _loadValues(FirebaseRemoteConfig.instance);
    // } catch (_) {}
  }
}
