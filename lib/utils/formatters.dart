String formatNumber(double value) {
  if (value >= 1e15) return '${(value / 1e15).toStringAsFixed(1)}Q';
  if (value >= 1e12) return '${(value / 1e12).toStringAsFixed(1)}T';
  if (value >= 1e9) return '${(value / 1e9).toStringAsFixed(1)}B';
  if (value >= 1e6) return '${(value / 1e6).toStringAsFixed(1)}M';
  if (value >= 1e3) return '${(value / 1e3).toStringAsFixed(1)}K';
  return value.toStringAsFixed(0);
}

String formatNumberPlus(double value) {
  return '+${formatNumber(value)}';
}
