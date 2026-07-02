import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../utils/constants.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        return Scaffold(
          backgroundColor: const Color(0xFF0E0E12),
          appBar: AppBar(
            backgroundColor: const Color(0xFF0E0E12),
            title: const Text(
              'Settings',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _SectionLabel(label: 'Audio & Haptic'),
              _ToggleTile(
                icon: Icons.volume_up,
                label: 'Sound Effects',
                value: !gp.audioService.isSoundMuted,
                onChanged: (_) {
                  gp.audioService.toggleSound();
                  (context as Element).markNeedsBuild();
                },
              ),
              _ToggleTile(
                icon: Icons.music_note,
                label: 'Music',
                value: !gp.audioService.isMusicMuted,
                onChanged: (_) {
                  gp.audioService.toggleMusic();
                  (context as Element).markNeedsBuild();
                },
              ),
              _ToggleTile(
                icon: Icons.vibration,
                label: 'Haptic Feedback',
                value: gp.hapticEnabled,
                onChanged: (_) => gp.toggleHaptic(),
              ),
              const SizedBox(height: 20),
              _SectionLabel(label: 'Save Data'),
              _ActionTile(
                icon: Icons.upload,
                label: 'Export Save',
                subtitle: 'Copy save data to clipboard',
                onTap: () => _exportSave(context, gp),
              ),
              _ActionTile(
                icon: Icons.download,
                label: 'Import Save',
                subtitle: 'Paste save data from clipboard',
                onTap: () => _importSave(context, gp),
              ),
              _ActionTile(
                icon: Icons.delete_forever,
                label: 'Reset Game',
                subtitle: 'Delete all progress permanently',
                danger: true,
                onTap: () => _resetGame(context, gp),
              ),
              const SizedBox(height: 20),
              _SectionLabel(label: 'About'),
              _ActionTile(
                icon: Icons.info_outline,
                label: 'Credits',
                subtitle: 'Idle Creator Empire',
                onTap: () => _showCredits(context),
              ),
              _ActionTile(
                icon: Icons.verified,
                label: 'Version',
                subtitle: GameConstants.appVersion,
                onTap: null,
              ),
              _ActionTile(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                subtitle: 'No data collected. Everything is local.',
                onTap: () => _showPrivacy(context),
              ),
            ],
          ),
        );
      },
    );
  }

  void _exportSave(BuildContext context, GameProvider gp) {
    final data = gp.exportSave();
    Clipboard.setData(ClipboardData(text: data));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Save data copied to clipboard!'),
        backgroundColor: Color(0xFF00E676),
      ),
    );
  }

  void _importSave(BuildContext context, GameProvider gp) {
    showDialog(
      context: context,
      builder: (ctx) {
        final controller = TextEditingController();
        return AlertDialog(
          backgroundColor: const Color(0xFF1A1A24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Import Save', style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Paste your save data below:',
                style: TextStyle(color: Colors.white.withAlpha(150), fontSize: 13),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                maxLines: 4,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                decoration: InputDecoration(
                  hintText: 'Paste save data here...',
                  hintStyle: TextStyle(color: Colors.white.withAlpha(60)),
                  filled: true,
                  fillColor: const Color(0xFF0E0E12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () async {
                  final data = await Clipboard.getData(Clipboard.kTextPlain);
                  if (data?.text != null) {
                    controller.text = data!.text!;
                  }
                },
                child: const Text('Paste from Clipboard', style: TextStyle(color: Color(0xFF2979FF))),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.white.withAlpha(150))),
            ),
            FilledButton(
              onPressed: () async {
                Navigator.of(ctx).pop();
                final success = await gp.importSave(controller.text.trim());
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Save imported successfully!' : 'Invalid save data.'),
                      backgroundColor: success ? const Color(0xFF00E676) : Colors.redAccent,
                    ),
                  );
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF2979FF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Import', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  void _resetGame(BuildContext context, GameProvider gp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.redAccent, size: 24),
            SizedBox(width: 8),
            Text('Reset Game', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          'This will permanently delete ALL your progress. This cannot be undone!\n\nConsider exporting your save first.',
          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withAlpha(150))),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              gp.resetGame();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Delete Everything', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _showCredits(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.videogame_asset, color: Color(0xFF7C4DFF), size: 36),
            SizedBox(height: 8),
            Text('Idle Creator Empire', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Version ${GameConstants.appVersion}',
              style: TextStyle(color: Colors.white.withAlpha(120), fontSize: 12),
            ),
            const SizedBox(height: 16),
            Text(
              'Built with Flutter & love.\n\nTap, grow, prestige, repeat!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacy(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Privacy Policy', style: TextStyle(color: Colors.white, fontSize: 18)),
        content: Text(
          'Idle Creator Empire does not collect, store, or transmit any personal data.\n\n'
          'All game data is stored locally on your device using SharedPreferences.\n\n'
          'No internet connection is required to play.\n\n'
          'No analytics, tracking, or third-party services are used.',
          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(ctx).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF7C4DFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Close', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withAlpha(150),
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white.withAlpha(180), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFF7C4DFF),
          ),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final bool danger;
  final VoidCallback? onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.subtitle,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = danger ? Colors.redAccent : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A24),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: danger ? Colors.redAccent : Colors.white.withAlpha(180), size: 22),
        title: Text(label, style: TextStyle(color: color, fontSize: 14)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: color.withAlpha(100), fontSize: 11),
        ),
        trailing: onTap != null
            ? Icon(Icons.chevron_right, color: Colors.white.withAlpha(60), size: 20)
            : null,
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
