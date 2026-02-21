import 'package:flutter/material.dart';
import 'package:pillprompt/core/constants/app_constants.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/l10n.dart';
import '../../core/widgets/group_card.dart';
import '../../core/widgets/section_title.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  static const _appVersion = '1.0.0';
  static const _contactEmail = 'support@pillprompt.app';
  static const _playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.pillprompt.app';

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    await launchUrl(uri);
  }

  void _shareApp(String message) {
    SharePlus.instance.share(ShareParams(text: message));
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.aboutTitle), centerTitle: true),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          20,
          8,
          20,
          MediaQuery.of(context).padding.bottom,
        ),
        children: [
          const SizedBox(height: 12),
          _AppHeader(textTheme: textTheme, l10n: l10n),
          const SizedBox(height: 28),

          // General
          SectionTitle(title: l10n.generalSection),
          const SizedBox(height: 12),
          GroupCard(
            children: [
              _AboutRow(
                icon: Icons.info_outline,
                title: l10n.version(_appVersion),
              ),
              const Divider(height: 1),
              _AboutRow(
                icon: Icons.email_outlined,
                title: l10n.aboutContactUs,
                subtitle: l10n.aboutContactEmail,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _launchEmail(_contactEmail),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Links
          SectionTitle(title: l10n.linksSection),
          const SizedBox(height: 12),
          GroupCard(
            children: [
              _AboutRow(
                icon: Icons.star_outline,
                title: l10n.aboutRateApp,
                subtitle: l10n.aboutRateAppSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _launchUrl(_playStoreUrl),
              ),
              const Divider(height: 1),
              _AboutRow(
                icon: Icons.share_outlined,
                title: l10n.aboutShareApp,
                subtitle: l10n.aboutShareAppSubtitle,
                trailing: const Icon(Icons.chevron_right),
                onTap: () => _shareApp(l10n.aboutShareMessage),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Legal
          SectionTitle(title: l10n.legalSection),
          const SizedBox(height: 12),
          GroupCard(
            children: [
              _AboutRow(
                icon: Icons.privacy_tip_outlined,
                title: l10n.privacyPolicy,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Replace with your hosted privacy policy URL
                },
              ),
              const Divider(height: 1),
              _AboutRow(
                icon: Icons.description_outlined,
                title: l10n.aboutTermsOfService,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  // TODO: Replace with your hosted terms of service URL
                },
              ),
              const Divider(height: 1),
              _AboutRow(
                icon: Icons.code_outlined,
                title: l10n.aboutOpenSourceLicenses,
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  showLicensePage(
                    context: context,
                    applicationName: l10n.appTitle,
                    applicationVersion: _appVersion,
                    applicationIcon: Container(
                      height: 56,
                      width: 56,
                      decoration: BoxDecoration(
                        color: AppColors.sage.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(AppConstants.appLogo),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _AppHeader extends StatelessWidget {
  const _AppHeader({required this.textTheme, required this.l10n});

  final TextTheme textTheme;
  final dynamic l10n;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 72,
          width: 72,
          decoration: BoxDecoration(
            color: AppColors.sage.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Image.asset(AppConstants.appLogo),
        ),
        const SizedBox(height: 14),
        Text(l10n.appTitle, style: textTheme.headlineSmall),
        const SizedBox(height: 6),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            l10n.aboutDescription,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}

class _AboutRow extends StatelessWidget {
  const _AboutRow({
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
