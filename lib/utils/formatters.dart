String formatNumber(double value) {
  if (value >= 1e15) return '${(value / 1e15).toStringAsFixed(1)}Q';
  if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(1)}T';
  if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
  if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
  if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
  if (value >= 100) return value.toStringAsFixed(0);
  if (value >= 10) return value.toStringAsFixed(1);
  if (value == value.roundToDouble()) return value.toStringAsFixed(0);
  return value.toStringAsFixed(1);
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  if (hours > 0 && minutes > 0) return '${hours}h ${minutes}m';
  if (hours > 0) return '${hours}h';
  if (minutes > 0) return '${minutes}m';
  return '${duration.inSeconds}s';
}
