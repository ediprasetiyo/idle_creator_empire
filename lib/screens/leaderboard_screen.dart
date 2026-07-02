import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/leaderboard_entry.dart';
import '../providers/game_provider.dart';
import '../utils/formatters.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Map<LeaderboardType, List<LeaderboardEntry>> _entries = {};
  final Map<LeaderboardType, bool> _loading = {};

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: LeaderboardType.values.length, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        _loadTab(LeaderboardType.values[_tabController.index]);
      }
    });
    _loadTab(LeaderboardType.values[0]);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTab(LeaderboardType type, {bool force = false}) async {
    if (_loading[type] == true) return;
    if (!force && _entries.containsKey(type)) return;

    setState(() => _loading[type] = true);
    final gp = context.read<GameProvider>();
    final entries = await gp.leaderboardService.getLeaderboard(type, forceRefresh: force);
    if (mounted) {
      setState(() {
        _entries[type] = entries;
        _loading[type] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        title: const Text(
          'Leaderboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          labelColor: const Color(0xFFFFD600),
          unselectedLabelColor: Colors.white.withAlpha(100),
          indicatorColor: const Color(0xFFFFD600),
          labelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          unselectedLabelStyle: const TextStyle(fontSize: 12),
          tabAlignment: TabAlignment.start,
          tabs: LeaderboardType.values.map((t) => Tab(text: t.label)).toList(),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: LeaderboardType.values.map((type) {
          final loading = _loading[type] == true;
          final entries = _entries[type];

          if (loading && entries == null) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFD600)),
            );
          }

          if (entries == null || entries.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.leaderboard, color: Colors.white.withAlpha(60), size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No entries yet',
                    style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: const Color(0xFFFFD600),
            backgroundColor: const Color(0xFF1A1A24),
            onRefresh: () => _loadTab(type, force: true),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return _LeaderboardRow(
                  entry: entries[index],
                  type: type,
                  isTopThree: index < 3,
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _LeaderboardRow extends StatelessWidget {
  final LeaderboardEntry entry;
  final LeaderboardType type;
  final bool isTopThree;

  const _LeaderboardRow({
    required this.entry,
    required this.type,
    required this.isTopThree,
  });

  Color get _rankColor {
    switch (entry.rank) {
      case 1:
        return const Color(0xFFFFD600);
      case 2:
        return const Color(0xFFB0BEC5);
      case 3:
        return const Color(0xFFFF8A65);
      default:
        return Colors.white.withAlpha(80);
    }
  }

  IconData get _rankIcon {
    switch (entry.rank) {
      case 1:
        return Icons.emoji_events;
      case 2:
        return Icons.emoji_events;
      case 3:
        return Icons.emoji_events;
      default:
        return Icons.tag;
    }
  }

  String _formatValue() {
    if (type == LeaderboardType.topPrestige) {
      return '${entry.value.toInt()} prestiges';
    }
    if (type == LeaderboardType.topIncome) {
      return '${formatNumber(entry.value)}/s';
    }
    return formatNumber(entry.value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isTopThree
            ? _rankColor.withAlpha(15)
            : const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
        border: isTopThree
            ? Border.all(color: _rankColor.withAlpha(40))
            : null,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: isTopThree
                ? Icon(_rankIcon, color: _rankColor, size: 22)
                : Text(
                    '#${entry.rank}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.displayName,
                  style: TextStyle(
                    color: isTopThree ? _rankColor : Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      entry.career,
                      style: TextStyle(
                        color: Colors.white.withAlpha(80),
                        fontSize: 11,
                      ),
                    ),
                    if (entry.prestigeCount > 0) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.diamond, color: const Color(0xFFE040FB).withAlpha(150), size: 10),
                      const SizedBox(width: 2),
                      Text(
                        '${entry.prestigeCount}',
                        style: TextStyle(
                          color: const Color(0xFFE040FB).withAlpha(150),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Text(
            _formatValue(),
            style: TextStyle(
              color: isTopThree ? _rankColor : const Color(0xFFFFD600),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
