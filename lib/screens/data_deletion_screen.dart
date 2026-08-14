import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';

class DataDeletionScreen extends StatelessWidget {
  const DataDeletionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        title: const Text(
          'Data Deletion',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF7C4DFF).withAlpha(40),
              ),
            ),
            child: Column(
              children: [
                const Icon(Icons.delete_outline,
                    color: Color(0xFF7C4DFF), size: 48),
                const SizedBox(height: 16),
                const Text(
                  'Your Data, Your Choice',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You have full control over your data in Idle Creator Empire.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _section('What Data Is Stored',
              'Idle Creator Empire stores the following data:\n\n'
              '- Game progress (level, coins, upgrades, achievements)\n'
              '- Game settings (audio, haptic preferences)\n'
              '- Daily login streak and mission progress\n'
              '- Purchase history (processed by Google Play)\n'
              '- Anonymous analytics data (via Firebase)\n\n'
              'All game data is stored locally on your device. '
              'Cloud save data, if enabled, is stored on secure servers.'),
          _section('How to Delete Local Data',
              'To delete all local game data:\n\n'
              '1. Open the app and go to More > Settings\n'
              '2. Scroll to "Save Data" section\n'
              '3. Tap "Reset Game"\n'
              '4. Confirm the deletion\n\n'
              'This permanently deletes all local game progress. '
              'This action cannot be undone.\n\n'
              'Alternatively, uninstalling the app will remove all '
              'locally stored data.'),
          _section('How to Delete Cloud Data',
              'If you have used the Cloud Save feature:\n\n'
              '1. Open Settings > Cloud Save\n'
              '2. Your cloud data is linked to your device\n'
              '3. Resetting the game clears your local data\n'
              '4. To request deletion of cloud data, contact us at '
              'support@idlecreatorempire.com\n\n'
              'Cloud data deletion requests are processed within 30 days.'),
          _section('How to Delete Analytics Data',
              'Analytics data collected by Firebase is anonymized and '
              'cannot be linked to individual users. This data is '
              'automatically deleted after 14 months in accordance with '
              'Firebase\'s data retention policies.\n\n'
              'To stop future analytics collection, uninstall the app.'),
          _section('In-App Purchase Data',
              'Purchase records are maintained by Google Play and are '
              'subject to Google\'s data retention policies. Contact '
              'Google Play support for questions about purchase data.'),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.redAccent.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.redAccent.withAlpha(60)),
            ),
            child: Column(
              children: [
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      'Delete All Data Now',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'This will permanently delete all your local game data '
                  'including progress, settings, and achievements.',
                  style: TextStyle(
                    color: Colors.white.withAlpha(150),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => _confirmDeletion(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.redAccent,
                      side: const BorderSide(color: Colors.redAccent),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete All Local Data'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _section('Contact Us',
              'For data deletion requests or questions about your data:\n\n'
              'Email: support@idlecreatorempire.com\n\n'
              'We will respond to all data-related requests within 30 days.'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  void _confirmDeletion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.redAccent, size: 24),
            SizedBox(width: 8),
            Expanded(
              child: Text('Confirm Deletion',
                  style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ALL local game data? '
          'This action is permanent and cannot be undone.',
          style: TextStyle(color: Colors.white.withAlpha(180), fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withAlpha(150))),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final gp = context.read<GameProvider>();
              gp.resetGame();
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Delete Everything',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: TextStyle(
              color: Colors.white.withAlpha(180),
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
