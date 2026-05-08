import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/settings_link_tile.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/settings_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';

class SettingsViewBody extends StatefulWidget {
  const SettingsViewBody({super.key});

  @override
  State<SettingsViewBody> createState() => _SettingsViewBodyState();
}

class _SettingsViewBodyState extends State<SettingsViewBody> {
  bool _pushNotifications = true;
  bool _emailAlerts = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _buildSectionHeader('NOTIFICATIONS'),
          SettingsSwitchTile(
            title: 'Push Notifications',
            icon: Icons.notifications_none_outlined,
            value: _pushNotifications,
            onChanged: (value) {
              setState(() {
                _pushNotifications = value;
              });
            },
          ),
          SettingsSwitchTile(
            title: 'Email Alerts',
            icon: Icons.mail_outline,
            value: _emailAlerts,
            onChanged: (value) {
              setState(() {
                _emailAlerts = value;
              });
            },
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('PREFERENCES'),
          SettingsSwitchTile(
            title: 'Dark Mode',
            icon: Icons.nightlight_round,
            value: ThemeManager.isDarkMode,
            onChanged: (value) async {
              final navigatorContext = context
                  .findAncestorStateOfType<NavigatorState>()
                  ?.context;
              await SharedPrefsHelper.setIsDarkMode(value);
              setState(() {
                ThemeManager.themeNotifier.value = value
                    ? ThemeMode.dark
                    : ThemeMode.light;
              });

              // Force the whole app to rebuild seamlessly to pick up AppColors
              // without destroying the current navigation stack!
              if (!mounted || navigatorContext == null) return;
              ThemeManager.forceAppRebuild(navigatorContext);
            },
          ),
          SettingsLinkTile(
            title: 'Language Selection',
            icon: Icons.language_outlined,
            subtitle: 'English / Arabic',
            onTap: () {},
          ),

          const SizedBox(height: 32),
          _buildSectionHeader('MORE'),
          SettingsLinkTile(
            title: 'Terms of Service',
            icon: Icons.description_outlined,
            onTap: () {},
          ),
          SettingsLinkTile(
            title: 'Help & Support',
            icon: Icons.help_outline,
            onTap: () {},
          ),
          const SizedBox(height: 48),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 12),
      child: Text(
        title,
        style: AppTextStyle.bold16.copyWith(
          color: const Color(0xff64748B), // Slate 500
          fontSize: 12,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
