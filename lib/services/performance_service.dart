import 'dart:async';

class PerformanceService {
  bool _initialized = false;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    // Integration point: Firebase Performance
    // FirebasePerformance.instance.setPerformanceCollectionEnabled(true);
    _initialized = true;
  }

  PerformanceTrace startTrace(String name) {
    // Integration point:
    // final trace = FirebasePerformance.instance.newTrace(name);
    // await trace.start();
    return PerformanceTrace._(name);
  }

  void setEnabled(bool enabled) {
    // FirebasePerformance.instance.setPerformanceCollectionEnabled(enabled);
  }
}

class PerformanceTrace {
  final String name;
  final int _startTime;
  bool _stopped = false;

  PerformanceTrace._(this.name) : _startTime = DateTime.now().millisecondsSinceEpoch;

  int get elapsedMs => DateTime.now().millisecondsSinceEpoch - _startTime;

  void putAttribute(String key, String value) {
    if (_stopped) return;
    // _trace.putAttribute(key, value);
  }

  void incrementMetric(String name, int value) {
    if (_stopped) return;
    // _trace.incrementMetric(name, value);
  }

  void stop() {
    if (_stopped) return;
    _stopped = true;
    // _trace.stop();
  }
}
