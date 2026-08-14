import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../services/cloud_save_service.dart';
import '../utils/constants.dart';
import 'privacy_screen.dart';
import 'terms_screen.dart';
import 'data_deletion_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameProvider>(
      builder: (context, gp, _) {
        final cloudStatus = gp.cloudSaveService.status;
        final isSyncing = cloudStatus == CloudSaveStatus.syncing;

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
              _SectionLabel(label: 'Cloud Save'),
              _ActionTile(
                icon: Icons.cloud_sync,
                label: 'Sync to Cloud',
                subtitle: isSyncing
                    ? 'Syncing...'
                    : gp.cloudSaveService.hasSynced
                        ? 'Last sync: ${_formatSyncTime(gp.cloudSaveService.lastSyncTimestamp)}'
                        : 'Backup your progress to the cloud',
                onTap: isSyncing ? null : () => _syncToCloud(context, gp),
              ),
              _ActionTile(
                icon: Icons.cloud_download,
                label: 'Load from Cloud',
                subtitle: 'Restore progress from cloud backup',
                onTap: isSyncing ? null : () => _loadFromCloud(context, gp),
              ),
              const SizedBox(height: 20),
              _SectionLabel(label: 'Purchases'),
              _ActionTile(
                icon: Icons.restore,
                label: 'Restore Purchases',
                subtitle: 'Restore previously bought items',
                onTap: () => _restorePurchases(context, gp),
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
                subtitle: 'View privacy information',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const PrivacyScreen()),
                ),
              ),
              _ActionTile(
                icon: Icons.description_outlined,
                label: 'Terms of Service',
                subtitle: 'View terms and conditions',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const TermsScreen()),
                ),
              ),
              _ActionTile(
                icon: Icons.delete_outline,
                label: 'Data Deletion',
                subtitle: 'Manage and delete your data',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const DataDeletionScreen()),
                ),
              ),
              _ActionTile(
                icon: Icons.source_outlined,
                label: 'Open Source Licenses',
                subtitle: 'Third-party software licenses',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Idle Creator Empire',
                  applicationVersion: GameConstants.appVersion,
                  applicationIcon: Container(
                    width: 60,
                    height: 60,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xFF7C4DFF), Color(0xFFE040FB)],
                      ),
                    ),
                    child: const Icon(Icons.play_circle_fill,
                        size: 30, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatSyncTime(int timestampMs) {
    final dt = DateTime.fromMillisecondsSinceEpoch(timestampMs);
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.month}/${dt.day} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }

  void _syncToCloud(BuildContext context, GameProvider gp) async {
    final result = await gp.syncToCloud();
    if (!context.mounted) return;

    String message;
    Color color;
    switch (result.status) {
      case CloudSaveStatus.success:
        message = 'Save synced to cloud!';
        color = const Color(0xFF00E676);
      case CloudSaveStatus.conflict:
        message = 'Conflict detected. Local save was kept.';
        color = const Color(0xFFFF9100);
      case CloudSaveStatus.error:
        message = result.error ?? 'Sync failed';
        color = Colors.redAccent;
      default:
        message = 'Sync complete';
        color = const Color(0xFF00E676);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  void _loadFromCloud(BuildContext context, GameProvider gp) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.cloud_download, color: Color(0xFF2979FF), size: 24),
            SizedBox(width: 8),
            Text('Load from Cloud', style: TextStyle(color: Colors.white, fontSize: 18)),
          ],
        ),
        content: Text(
          'This will replace your current local save with the cloud save. '
          'Any local progress not synced will be lost.\n\nContinue?',
          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel', style: TextStyle(color: Colors.white.withAlpha(150))),
          ),
          FilledButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              final cloudResult = await gp.cloudSaveService.downloadSave();
              if (!context.mounted) return;
              if (cloudResult.cloudData != null && cloudResult.cloudData!.containsKey('data')) {
                final success = await gp.loadFromCloud(cloudResult.cloudData!['data'] as String);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(success ? 'Cloud save loaded!' : 'Failed to load cloud save.'),
                      backgroundColor: success ? const Color(0xFF00E676) : Colors.redAccent,
                    ),
                  );
                }
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('No cloud save found.'),
                    backgroundColor: Color(0xFFFF9100),
                  ),
                );
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF2979FF),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Load', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _restorePurchases(BuildContext context, GameProvider gp) async {
    final success = await gp.restorePurchases();
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Purchases restored successfully!' : 'Could not restore purchases.'),
          backgroundColor: success ? const Color(0xFF00E676) : Colors.redAccent,
        ),
      );
    }
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
    return Semantics(
      toggled: value,
      label: '$label toggle',
      child: Container(
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

    return Semantics(
      button: onTap != null,
      label: label,
      child: Container(
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
      ),
    );
  }
}
