import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        title: const Text(
          'Terms of Service',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white.withAlpha(200)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Last updated: August 2026',
            style: TextStyle(color: Colors.white.withAlpha(100), fontSize: 12),
          ),
          const SizedBox(height: 20),
          _section('1. Acceptance of Terms',
              'By downloading, installing, or using Idle Creator Empire '
              '("the App"), you agree to be bound by these Terms of Service. '
              'If you do not agree to these terms, do not use the App.'),
          _section('2. Game Description',
              'Idle Creator Empire is a free-to-play idle clicker game where '
              'players build a virtual content creator empire. The game '
              'includes virtual currency, in-app purchases, and advertisements.'),
          _section('3. Virtual Currency and Items',
              'The App contains virtual currency ("Coins") and virtual items '
              'that can be earned through gameplay or purchased with real money. '
              'Virtual currency and items:\n\n'
              '- Have no real-world monetary value\n'
              '- Cannot be exchanged for real currency\n'
              '- Cannot be transferred between accounts\n'
              '- May be modified or removed at our discretion\n'
              '- Are licensed to you, not sold'),
          _section('4. In-App Purchases',
              'The App offers optional in-app purchases. All purchases are '
              'processed through Google Play and are subject to Google Play\'s '
              'terms and refund policies.\n\n'
              'Purchases are final unless otherwise required by applicable law. '
              'You can restore previously purchased non-consumable items using '
              'the Restore Purchases option in Settings.\n\n'
              'Prices are displayed in your local currency and may vary by '
              'region. We reserve the right to modify pricing at any time.'),
          _section('5. Advertisements',
              'The App displays advertisements through Google AdMob. Some '
              'features offer optional ad viewing for in-game rewards. You are '
              'not required to watch ads to progress in the game.\n\n'
              'Ad content is provided by third-party advertisers and does not '
              'represent endorsement by us.'),
          _section('6. User Conduct',
              'You agree not to:\n\n'
              '- Modify, reverse-engineer, or decompile the App\n'
              '- Use cheats, exploits, or automation software\n'
              '- Attempt to manipulate game data or save files to gain unfair '
              'advantages\n'
              '- Distribute modified versions of the App\n'
              '- Use the App for any unlawful purpose'),
          _section('7. Account and Data',
              'The App does not require account registration. Game progress is '
              'stored locally on your device. Optional cloud save requires '
              'authentication through supported providers.\n\n'
              'You are responsible for maintaining the security of your device '
              'and any accounts linked to cloud save functionality.'),
          _section('8. Intellectual Property',
              'All content in the App, including but not limited to graphics, '
              'text, code, audio, and game mechanics, is owned by us and '
              'protected by intellectual property laws. You are granted a '
              'limited, non-exclusive, non-transferable license to use the App '
              'for personal, non-commercial purposes.'),
          _section('9. Disclaimer of Warranties',
              'The App is provided "as is" without warranties of any kind, '
              'either express or implied. We do not guarantee that the App will '
              'be error-free, uninterrupted, or free of harmful components.\n\n'
              'Game progress may be lost due to device failure, app updates, or '
              'other circumstances. We recommend using the Export Save and Cloud '
              'Save features regularly.'),
          _section('10. Limitation of Liability',
              'To the maximum extent permitted by law, we shall not be liable '
              'for any indirect, incidental, special, or consequential damages '
              'arising from your use of the App, including but not limited to '
              'loss of game progress or virtual items.'),
          _section('11. Modifications',
              'We reserve the right to modify the App, including game balance, '
              'features, virtual currency values, and these Terms of Service '
              'at any time. Continued use of the App after modifications '
              'constitutes acceptance of the updated terms.'),
          _section('12. Termination',
              'We may terminate or suspend your access to the App at any time '
              'for violation of these terms. Upon termination, your license to '
              'use the App is immediately revoked.'),
          _section('13. Governing Law',
              'These terms shall be governed by and construed in accordance '
              'with applicable laws. Any disputes shall be resolved through '
              'binding arbitration or in courts of competent jurisdiction.'),
          _section('14. Contact',
              'For questions about these Terms of Service, contact us at:\n\n'
              'Email: support@idlecreatorempire.com'),
          const SizedBox(height: 40),
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
