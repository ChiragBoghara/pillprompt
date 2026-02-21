import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pillprompt/core/constants/app_constants.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../l10n/l10n.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) {
        Get.offAllNamed(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.surface,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: AppColors.sage.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Image.asset(AppConstants.appLogo),
              ),
              const SizedBox(height: 16),
              Text('PillPrompt', style: textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(l10n.splashTagline, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
