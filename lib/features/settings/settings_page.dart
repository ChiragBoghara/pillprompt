import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/settings_controller.dart';
import '../../core/widgets/group_card.dart';
import '../../core/widgets/section_title.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final controller = Get.find<SettingsController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            const SectionTitle(title: 'Preferences'),
            const SizedBox(height: 12),
            GroupCard(
              children: [
                Obx(
                  () => _SettingsRow(
                    icon: Icons.brightness_6_outlined,
                    title: 'Theme',
                    trailing: Switch.adaptive(
                      value: controller.themeMode.value == ThemeMode.dark,
                      onChanged: (value) {
                        controller.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                      },
                      activeTrackColor: AppColors.sage,
                    ),
                  ),
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.language_outlined,
                  title: 'Language',
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('English', style: textTheme.bodyMedium),
                      const SizedBox(width: 6),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Alerts'),
            const SizedBox(height: 12),
            GroupCard(
              children: [
                Obx(
                  () => _SettingsRow(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications',
                    subtitle: controller.notificationsEnabled.value
                        ? 'Permission: Enabled'
                        : 'Permission: Disabled',
                    trailing: FilledButton(
                      onPressed: controller.requestNotificationPermission,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.sage.withValues(alpha: 0.12),
                        foregroundColor: AppColors.sage,
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        textStyle: textTheme.labelLarge,
                      ),
                      child: const Text('Manage'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SectionTitle(title: 'Support'),
            const SizedBox(height: 12),
            GroupCard(
              children: [
                _SettingsRow(
                  icon: Icons.info_outline,
                  title: 'About PillPrompt',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
                const Divider(height: 1),
                _SettingsRow(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 28),
            Column(
              children: [
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: AppColors.sage.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.medication_outlined, color: AppColors.sage),
                ),
                const SizedBox(height: 10),
                Text('PillPrompt', style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('Version 1.0.0', style: textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.sage.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.sage),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: textTheme.labelLarge),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(subtitle!, style: textTheme.bodyMedium),
                  ],
                ],
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
