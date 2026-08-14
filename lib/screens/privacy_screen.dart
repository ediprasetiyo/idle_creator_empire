import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E0E12),
        title: const Text(
          'Privacy Policy',
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
          _section('1. Information We Collect',
              'Idle Creator Empire collects the following types of information:\n\n'
              'Game Data: Your game progress, including level, coins, upgrades, '
              'achievements, and settings are stored locally on your device using '
              'SharedPreferences.\n\n'
              'Analytics Data: We collect anonymous usage data such as session '
              'duration, feature usage, level progression, and crash reports to '
              'improve the game experience. This data does not include personally '
              'identifiable information.\n\n'
              'Advertising Data: Our advertising partner, Google AdMob, may '
              'collect device identifiers and usage data to serve personalized '
              'or non-personalized ads based on your consent preferences.\n\n'
              'Purchase Data: In-app purchase transactions are processed by '
              'Google Play. We do not store payment information.'),
          _section('2. How We Use Your Information',
              'We use the collected information to:\n\n'
              '- Save and restore your game progress\n'
              '- Provide cloud save backup functionality\n'
              '- Improve game balance and user experience\n'
              '- Display relevant advertisements\n'
              '- Process in-app purchases\n'
              '- Diagnose crashes and technical issues'),
          _section('3. Data Storage',
              'Game data is stored locally on your device. If you enable cloud '
              'save, your game progress is encrypted and stored securely on our '
              'servers. You can delete your cloud data at any time through the '
              'Settings menu.\n\n'
              'Analytics data is processed by Firebase Analytics and stored on '
              'Google servers in accordance with Google\'s privacy policy.'),
          _section('4. Third-Party Services',
              'This app integrates the following third-party services:\n\n'
              '- Google AdMob: For displaying advertisements\n'
              '- Google Firebase: For analytics, crash reporting, and cloud services\n'
              '- Google Play Billing: For in-app purchases\n\n'
              'Each service has its own privacy policy governing data collection '
              'and usage. We encourage you to review their policies.'),
          _section('5. Children\'s Privacy',
              'Idle Creator Empire is designed for a general audience. We do not '
              'knowingly collect personal information from children under 13. '
              'The app complies with COPPA (Children\'s Online Privacy Protection '
              'Act) requirements. Ads shown to users under 13 are '
              'non-personalized.'),
          _section('6. Data Sharing',
              'We do not sell, trade, or otherwise transfer your personal '
              'information to third parties. Anonymous, aggregated analytics '
              'data may be shared with third-party services as described above '
              'for the purpose of improving the app.'),
          _section('7. Your Rights',
              'You have the right to:\n\n'
              '- Access your game data (via Export Save in Settings)\n'
              '- Delete your game data (via Reset Game in Settings)\n'
              '- Request deletion of cloud save data\n'
              '- Opt out of personalized advertising\n'
              '- Withdraw consent for data collection'),
          _section('8. Data Security',
              'We implement appropriate security measures to protect your data. '
              'Local game data is stored in the app\'s private storage area. '
              'Cloud save data is encrypted during transmission and at rest.'),
          _section('9. Changes to This Policy',
              'We may update this privacy policy from time to time. Any changes '
              'will be reflected in the "Last updated" date at the top of this '
              'page. Continued use of the app after changes constitutes '
              'acceptance of the updated policy.'),
          _section('10. Contact Us',
              'If you have questions about this privacy policy or your data, '
              'please contact us at:\n\n'
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
