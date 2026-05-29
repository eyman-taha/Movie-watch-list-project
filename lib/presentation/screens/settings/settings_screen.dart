import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../providers/settings_providers.dart';
import '../../providers/providers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);
    final isDarkMode = themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Appearance'),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Dark Mode',
            subtitle: isDarkMode ? 'Enabled' : 'Disabled',
            trailing: Switch.adaptive(
              value: isDarkMode,
              onChanged: (value) {
                ref.read(themeModeProvider.notifier).toggleTheme();
              },
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Notifications'),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive updates about new movies',
            trailing: Switch.adaptive(
              value: _notificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _notificationsEnabled = value;
                });
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications_enabled', value);
              },
              activeTrackColor: AppTheme.primaryColor,
            ),
          ),
          _buildSettingsTile(
            icon: Icons.email_outlined,
            title: 'Email Notifications',
            subtitle: 'Weekly digest and recommendations',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showSnackBar('Email notifications coming soon'),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Content'),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(),
          ),
          _buildSettingsTile(
            icon: Icons.movie_filter_outlined,
            title: 'Content Rating',
            subtitle: 'All ages',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showContentRatingDialog(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Storage'),
          _buildSettingsTile(
            icon: Icons.cached_outlined,
            title: 'Clear Cache',
            subtitle: 'Free up storage space',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showClearCacheDialog(),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('About'),
          _buildSettingsTile(
            icon: Icons.info_outlined,
            title: 'About CineWatch',
            subtitle: 'Version 1.0.0',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showAboutDialog(),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'Learn how we handle your data',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => launchUrl(Uri.parse('https://github.com/eyman-taha/Movie-watch-list-project/blob/main/PRIVACY.md'), mode: LaunchMode.externalApplication),
          ),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => launchUrl(Uri.parse('https://github.com/eyman-taha/Movie-watch-list-project/blob/main/TERMS.md'), mode: LaunchMode.externalApplication),
          ),
          _buildSettingsTile(
            icon: Icons.code_outlined,
            title: 'Open Source Licenses',
            subtitle: 'Third-party libraries',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => showLicensePage(
              context: context,
              applicationName: 'CineWatch',
              applicationVersion: '1.0.0',
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionHeader('Support'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help & FAQ',
            subtitle: 'Get answers to common questions',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => launchUrl(Uri.parse('https://github.com/eyman-taha/Movie-watch-list-project/issues'), mode: LaunchMode.externalApplication),
          ),
          _buildSettingsTile(
            icon: Icons.feedback_outlined,
            title: 'Send Feedback',
            subtitle: 'Help us improve the app',
            trailing: const Icon(Icons.chevron_right),
            onTap: () => launchUrl(Uri.parse('https://github.com/eyman-taha/Movie-watch-list-project/issues/new'), mode: LaunchMode.externalApplication),
          ),
          const SizedBox(height: 32),
          _buildSignOutButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppTheme.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryColor, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(
          subtitle,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSignOutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () => _showSignOutDialog(),
        icon: const Icon(Icons.logout, color: Colors.red),
        label: const Text('Sign Out', style: TextStyle(color: Colors.red)),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.red),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Language'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('English'), leading: Icon(Icons.check), selected: true),
            ListTile(title: Text('Spanish'), leading: Icon(Icons.add), enabled: false),
            ListTile(title: Text('French'), leading: Icon(Icons.add), enabled: false),
            ListTile(title: Text('Arabic'), leading: Icon(Icons.add), enabled: false),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  void _showContentRatingDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Content Rating'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text('All Ages'), leading: Icon(Icons.check), selected: true),
            ListTile(title: Text('Teen (13+)'), leading: Icon(Icons.add), enabled: false),
            ListTile(title: Text('Adult (18+)'), leading: Icon(Icons.add), enabled: false),
          ],
        ),
        actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close'))],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
          'This will clear all cached data including movie images and search history. Your watchlist will not be affected.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref.read(clearCacheProvider)();
              if (ctx.mounted) Navigator.pop(ctx);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cache cleared successfully')),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.movie_filter, color: Colors.white),
            ),
            const SizedBox(width: 12),
            const Text('CineWatch'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Version 1.0.0'),
            SizedBox(height: 16),
            Text(
              'CineWatch is your ultimate movie companion. Discover new movies, track your watchlist, and never miss a great film.',
              style: TextStyle(height: 1.5),
            ),
            SizedBox(height: 16),
            Text('Powered by TMDB API', style: TextStyle(color: Colors.grey)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await ref.read(authNotifierProvider.notifier).signOut();
              if (mounted) {
                context.go('/login');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }
}
