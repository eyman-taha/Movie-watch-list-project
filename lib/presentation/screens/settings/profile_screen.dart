import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/watchlist_item.dart';
import '../../providers/watchlist_providers.dart';
import '../../providers/settings_providers.dart';
import '../../providers/providers.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadNotificationPref();
  }

  Future<void> _loadNotificationPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    });
  }

  Future<void> _openUrl(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Could not open: $url'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);
    final watchlist = ref.watch(watchlistProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(child: _buildHeader(context, user)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildStatsSection(watchlist),
              ),
            ),
            SliverToBoxAdapter(child: _buildQuickActions(context)),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: _buildAccountSection(context, ref),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildAppearanceSection(context, ref),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildNotificationsSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildSupportSection(),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildAboutSection(context, ref),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: _buildDangerZone(context, ref),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  // ─── HEADER ────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, User? user) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppTheme.primaryColor.withValues(alpha: isDark ? 0.18 : 0.10),
            theme.scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryColor, width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withValues(alpha: isDark ? 0.35 : 0.20),
                      blurRadius: 24,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 52,
                  backgroundColor: AppTheme.primaryColor,
                  backgroundImage: user?.photoUrl != null
                      ? NetworkImage(user!.photoUrl!)
                      : null,
                  child: user?.photoUrl == null
                      ? Text(
                          _getInitials(user),
                          style: const TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      : null,
                ),
              ),
              GestureDetector(
                onTap: () => _showEditProfile(context, ref),
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: theme.scaffoldBackgroundColor, width: 2),
                  ),
                  child: const Icon(Icons.edit, size: 16, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            user?.displayName ?? 'Movie Lover',
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            user?.email ?? 'Welcome to CineWatch',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: isDark ? 0.15 : 0.10),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: isDark ? 0.3 : 0.2),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.star, size: 14, color: AppTheme.secondaryColor),
                const SizedBox(width: 6),
                Text(
                  'Member',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(User? user) {
    if (user == null) return 'U';
    if (user.displayName != null && user.displayName!.isNotEmpty) {
      final parts = user.displayName!.split(' ');
      if (parts.length > 1) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return user.displayName![0].toUpperCase();
    }
    if (user.email.isNotEmpty) return user.email[0].toUpperCase();
    return 'U';
  }

  // ─── STATS ─────────────────────────────────────────────────────────

  Widget _buildStatsSection(AsyncValue<List<WatchlistItem>> watchlist) {
    return watchlist.when(
      data: (items) => _buildStatsGrid(items),
      loading: () => _buildStatsLoading(),
      error: (_, _) => _buildStatsGrid([]),
    );
  }

  Widget _buildStatsGrid(List<WatchlistItem> items) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final planToWatch = items.where((i) => i.status == WatchlistStatus.planToWatch).length;
    final stillWatching = items.where((i) => i.status == WatchlistStatus.stillWatching).length;
    final watched = items.where((i) => i.status == WatchlistStatus.watched).length;
    final favorites = items.where((i) => i.isFavorite).length;

    final stats = [
      _StatData(Icons.schedule, planToWatch.toString(), 'Plan to Watch', Colors.orange),
      _StatData(Icons.play_circle, stillWatching.toString(), 'Watching', Colors.blue),
      _StatData(Icons.check_circle, watched.toString(), 'Watched', Colors.green),
      _StatData(Icons.favorite, favorites.toString(), 'Favorites', Colors.red),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.08),
        ),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics_outlined, size: 18, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
              const SizedBox(width: 8),
              Text(
                'Your Stats',
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatItem(stats[0])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatItem(stats[1])),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem(stats[2])),
              const SizedBox(width: 12),
              Expanded(child: _buildStatItem(stats[3])),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(_StatData data) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: data.color.withValues(alpha: isDark ? 0.10 : 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(data.icon, color: data.color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) {
                  return FadeTransition(opacity: animation, child: child);
                },
                child: Text(
                  data.value,
                  key: ValueKey(data.value),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: data.color,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.label,
                style: TextStyle(
                  fontSize: 11,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatsLoading() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(height: 16, width: 100, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(4))),
          const SizedBox(height: 20),
          Row(children: [
            Expanded(child: Container(height: 64, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)))),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 64, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)))),
          ]),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: Container(height: 64, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)))),
            const SizedBox(width: 12),
            Expanded(child: Container(height: 64, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(14)))),
          ]),
        ],
      ),
    );
  }

  // ─── QUICK ACTIONS ─────────────────────────────────────────────────

  Widget _buildQuickActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Row(
        children: [
          Expanded(child: _buildActionButton(
            icon: Icons.explore_outlined,
            activeIcon: Icons.explore,
            label: 'Discover',
            color: AppTheme.primaryColor,
            onTap: () => context.go('/search'),
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildActionButton(
            icon: Icons.bookmark_border,
            activeIcon: Icons.bookmark,
            label: 'Watchlist',
            color: Colors.blue,
            onTap: () => context.go('/watchlist'),
          )),
          const SizedBox(width: 12),
          Expanded(child: _buildActionButton(
            icon: Icons.home_outlined,
            activeIcon: Icons.home,
            label: 'Home',
            color: Colors.green,
            onTap: () => context.go('/home'),
          )),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: color.withValues(alpha: 0.15),
        highlightColor: color.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: isDark ? 0.10 : 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withValues(alpha: isDark ? 0.25 : 0.15),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 26),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SETTINGS GROUP BASE ───────────────────────────────────────────

  Widget _buildSettingsGroup({
    required IconData groupIcon,
    required String groupTitle,
    required List<Widget> items,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(groupIcon, size: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 6),
              Text(
                groupTitle.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.08),
            ),
            boxShadow: [
              if (!isDark)
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildSettingsDivider() {
    final theme = Theme.of(context);
    return Divider(
      height: 1,
      thickness: 1,
      indent: 60,
      color: theme.colorScheme.onSurface.withValues(alpha: 0.06),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final effectiveColor = iconColor ?? AppTheme.primaryColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        splashColor: effectiveColor.withValues(alpha: 0.08),
        highlightColor: effectiveColor.withValues(alpha: 0.04),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: effectiveColor.withValues(alpha: isDark ? 0.12 : 0.08),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(icon, color: effectiveColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null)
                trailing
              else if (onTap != null)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── ACCOUNT SECTION ───────────────────────────────────────────────

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    return _buildSettingsGroup(
      groupIcon: Icons.person_outline,
      groupTitle: 'Account',
      items: [
        _buildSettingsTile(
          icon: Icons.edit_outlined,
          title: 'Edit Profile',
          subtitle: 'Update your name and photo',
          onTap: () => _showEditProfile(context, ref),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.language_outlined,
          title: 'Language',
          subtitle: _getCurrentLanguageName(),
          onTap: () => _showLanguageDialog(),
        ),
      ],
    );
  }

  String _getCurrentLanguageName() {
    final locale = ref.read(localeProvider);
    return locale.languageCode == 'ar' ? 'العربية' : 'English';
  }

  // ─── APPEARANCE SECTION ────────────────────────────────────────────

  Widget _buildAppearanceSection(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final isDark = themeMode == ThemeMode.dark;

    return _buildSettingsGroup(
      groupIcon: Icons.palette_outlined,
      groupTitle: 'Appearance',
      items: [
        _buildSettingsTile(
          icon: isDark ? Icons.dark_mode : Icons.light_mode,
          title: 'Dark Mode',
          subtitle: isDark ? 'Enabled' : 'Disabled',
          iconColor: isDark ? const Color(0xFF7C4DFF) : const Color(0xFFFFB300),
          trailing: Switch.adaptive(
            value: isDark,
            onChanged: (v) {
              ref.read(themeModeProvider.notifier).toggleTheme();
            },
            activeTrackColor: AppTheme.primaryColor,
          ),
          onTap: null,
        ),
      ],
    );
  }

  // ─── NOTIFICATIONS SECTION ─────────────────────────────────────────

  Widget _buildNotificationsSection() {
    final theme = Theme.of(context);

    return _buildSettingsGroup(
      groupIcon: Icons.notifications_outlined,
      groupTitle: 'Notifications',
      items: [
        _buildSettingsTile(
          icon: Icons.notifications_outlined,
          title: 'Push Notifications',
          subtitle: _notificationsEnabled ? 'Enabled' : 'Disabled',
          iconColor: _notificationsEnabled
              ? AppTheme.primaryColor
              : theme.colorScheme.onSurface.withValues(alpha: 0.4),
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
      ],
    );
  }

  // ─── SUPPORT SECTION ───────────────────────────────────────────────

  Widget _buildSupportSection() {
    return _buildSettingsGroup(
      groupIcon: Icons.help_outline,
      groupTitle: 'Support',
      items: [
        _buildSettingsTile(
          icon: Icons.help_outline,
          title: 'Help & FAQ',
          subtitle: 'Get answers to common questions',
          onTap: () => _openUrl('https://github.com/eyman-taha/Movie-watch-list-project/issues'),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.feedback_outlined,
          title: 'Send Feedback',
          subtitle: 'Help us improve the app',
          onTap: () => _openUrl('https://github.com/eyman-taha/Movie-watch-list-project/issues/new'),
        ),
      ],
    );
  }

  // ─── ABOUT SECTION ─────────────────────────────────────────────────

  Widget _buildAboutSection(BuildContext context, WidgetRef ref) {
    return _buildSettingsGroup(
      groupIcon: Icons.info_outline,
      groupTitle: 'About',
      items: [
        _buildSettingsTile(
          icon: Icons.movie_filter_outlined,
          title: 'About CineWatch',
          subtitle: 'Version 1.0.0',
          onTap: () => _showAbout(context),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.privacy_tip_outlined,
          title: 'Privacy Policy',
          subtitle: 'Learn how we handle your data',
          onTap: () => _openUrl('https://github.com/eyman-taha/Movie-watch-list-project/blob/main/PRIVACY.md'),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.description_outlined,
          title: 'Terms of Service',
          subtitle: 'Read our terms',
          onTap: () => _openUrl('https://github.com/eyman-taha/Movie-watch-list-project/blob/main/TERMS.md'),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.cached_outlined,
          title: 'Clear Cache',
          subtitle: 'Free up storage space',
          onTap: () => _showClearCacheDialog(),
        ),
        _buildSettingsDivider(),
        _buildSettingsTile(
          icon: Icons.code_outlined,
          title: 'Open Source Licenses',
          subtitle: 'Third-party libraries',
          onTap: () => showLicensePage(
            context: context,
            applicationName: 'CineWatch',
            applicationVersion: '1.0.0',
          ),
        ),
      ],
    );
  }

  // ─── DANGER ZONE ───────────────────────────────────────────────────

  Widget _buildDangerZone(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Row(
            children: [
              Icon(Icons.warning_amber_outlined, size: 16, color: Colors.red.withValues(alpha: 0.5)),
              const SizedBox(width: 6),
              Text(
                'DANGER ZONE'.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: Colors.red.withValues(alpha: 0.5),
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: isDark ? 0.06 : 0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.08),
            ),
          ),
          child: Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showSignOutDialog(context, ref),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  splashColor: Colors.red.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: isDark ? 0.12 : 0.08),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(Icons.logout, color: Colors.red, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 20, color: Colors.red.withValues(alpha: 0.4)),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                indent: 60,
                color: Colors.red.withValues(alpha: isDark ? 0.08 : 0.06),
              ),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _showDeleteAccountDialog(context, ref),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                  splashColor: Colors.red.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: isDark ? 0.08 : 0.05),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Delete Account',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              Text(
                                'Permanently delete your account',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.45),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(Icons.chevron_right, size: 20, color: Colors.red.withValues(alpha: 0.4)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ─── DIALOGS / BOTTOM SHEETS ───────────────────────────────────────

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
                  const SnackBar(
                    content: Text('Cache cleared successfully'),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog() {
    final currentLocale = ref.read(localeProvider);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              leading: Icon(
                currentLocale.languageCode == 'en' ? Icons.check : null,
                color: AppTheme.primaryColor,
              ),
              selected: currentLocale.languageCode == 'en',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('en');
                Navigator.pop(ctx);
              },
            ),
            ListTile(
              title: const Text('العربية'),
              leading: Icon(
                currentLocale.languageCode == 'ar' ? Icons.check : null,
                color: AppTheme.primaryColor,
              ),
              selected: currentLocale.languageCode == 'ar',
              onTap: () {
                ref.read(localeProvider.notifier).setLocale('ar');
                Navigator.pop(ctx);
              },
            ),
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

  Future<void> _showEditProfile(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final user = ref.read(currentUserProvider);
    final nameController = TextEditingController(text: user?.displayName ?? '');

    try {
      await showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (ctx) => Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24, right: 24, top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Edit Profile',
                style: theme.textTheme.displaySmall,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Display Name',
                  prefixIcon: const Icon(Icons.person_outline),
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      await ref.read(authNotifierProvider.notifier).updateProfile(
                        displayName: nameController.text,
                      );
                      if (ctx.mounted) Navigator.pop(ctx);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Profile updated!'),
                            backgroundColor: Colors.green,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      }
                    } catch (_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Failed to update profile'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Save Changes'),
                ),
              ),
            ],
          ),
        ),
      );
    } finally {
      nameController.dispose();
    }
  }

  void _showAbout(BuildContext context) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40, height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(Icons.movie_filter, size: 60, color: Colors.white),
            ),
            const SizedBox(height: 24),
            Text(
              'CineWatch',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Version 1.0.0',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
            ),
            const SizedBox(height: 24),
            Text(
              'Your ultimate movie companion.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(ctx),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.logout, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 24),
            Text(
              'Sign Out',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'Are you sure you want to sign out?',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      await ref.read(authNotifierProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Sign Out'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.delete_forever, size: 40, color: Colors.red),
            ),
            const SizedBox(height: 24),
            Text(
              'Delete Account',
              style: theme.textTheme.displaySmall,
            ),
            const SizedBox(height: 12),
            Text(
              'This will permanently delete your account and all watchlist data. This action cannot be undone.',
              style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(ctx);
                      if (context.mounted) {
                        await ref.read(watchlistProvider.notifier).refresh();
                      }
                      final success = await ref.read(authNotifierProvider.notifier).deleteAccount();
                      if (context.mounted) {
                        if (success) {
                          context.go('/login');
                        } else {
                          final error = ref.read(authNotifierProvider).error;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(error ?? 'Failed to delete account'),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatData {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatData(this.icon, this.value, this.label, this.color);
}
