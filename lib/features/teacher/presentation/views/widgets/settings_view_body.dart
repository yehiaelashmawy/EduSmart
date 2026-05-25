import 'package:school_system/core/helper/shared_prefs_helper.dart';
import 'package:school_system/core/utils/theme_manager.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/settings_link_tile.dart';
import 'package:school_system/features/teacher/presentation/views/widgets/settings_switch_tile.dart';
import 'package:flutter/material.dart';
import 'package:school_system/core/utils/app_text_style.dart';
import 'package:school_system/core/utils/app_colors.dart';
import 'package:school_system/core/helper/localization_helper.dart';

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
    return ValueListenableBuilder<Locale>(
      valueListenable: LocalizationHelper.localeNotifier,
      builder: (context, _, _) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              _buildSectionHeader('notifications_header'.tr()),
              SettingsSwitchTile(
                title: 'push_notifications'.tr(),
                icon: Icons.notifications_none_outlined,
                value: _pushNotifications,
                onChanged: (value) {
                  setState(() {
                    _pushNotifications = value;
                  });
                },
              ),
              SettingsSwitchTile(
                title: 'email_alerts'.tr(),
                icon: Icons.mail_outline,
                value: _emailAlerts,
                onChanged: (value) {
                  setState(() {
                    _emailAlerts = value;
                  });
                },
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('preferences_header'.tr()),
              SettingsSwitchTile(
                title: 'dark_mode'.tr(),
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
                  // ignore: use_build_context_synchronously
                  ThemeManager.forceAppRebuild(navigatorContext);
                },
              ),
              SettingsLinkTile(
                title: 'language_selection'.tr(),
                icon: Icons.language_outlined,
                subtitle: LocalizationHelper.isArabic ? 'العربية' : 'English',
                onTap: () {
                  // Capture the outer context before opening the sheet
                  final outerContext = context;
                  showModalBottomSheet(
                    context: context,
                    backgroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                    ),
                    builder: (modalContext) {
                      return SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'select_language'.tr(),
                                style: AppTextStyle.bold18.copyWith(
                                  color: AppColors.darkBlue,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ListTile(
                                leading: const Text(
                                  '🇺🇸',
                                  style: TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  'english'.tr(),
                                  style: AppTextStyle.medium16,
                                ),
                                trailing: !LocalizationHelper.isArabic
                                    ? Icon(
                                        Icons.check,
                                        color: AppColors.primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  LocalizationHelper.setLanguage('en');
                                  Navigator.pop(modalContext);
                                  // Rebuild the full app so every .tr() widget updates
                                  ThemeManager.forceAppRebuild(outerContext);
                                },
                              ),
                              ListTile(
                                leading: const Text(
                                  '🇪🇬',
                                  style: TextStyle(fontSize: 24),
                                ),
                                title: Text(
                                  'arabic'.tr(),
                                  style: AppTextStyle.medium16,
                                ),
                                trailing: LocalizationHelper.isArabic
                                    ? Icon(
                                        Icons.check,
                                        color: AppColors.primaryColor,
                                      )
                                    : null,
                                onTap: () {
                                  LocalizationHelper.setLanguage('ar');
                                  Navigator.pop(modalContext);
                                  // Rebuild the full app so every .tr() widget updates
                                  ThemeManager.forceAppRebuild(outerContext);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 32),
              _buildSectionHeader('more_header'.tr()),
              SettingsLinkTile(
                title: 'terms_of_service'.tr(),
                icon: Icons.description_outlined,
                onTap: () {},
              ),
              SettingsLinkTile(
                title: 'help_support'.tr(),
                icon: Icons.help_outline,
                onTap: () {},
              ),
              const SizedBox(height: 48),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
