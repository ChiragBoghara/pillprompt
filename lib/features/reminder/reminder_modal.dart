import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/log_controller.dart';
import '../../core/constants/domain_constants.dart';
import '../../core/helpers/localization_helpers.dart';
import '../../core/helpers/snackbar_helpers.dart';
import '../../data/models/medicine_log.dart';
import '../../l10n/l10n.dart';
import '../../services/notification_service.dart';

class ReminderActionModal extends StatelessWidget {
  const ReminderActionModal({
    super.key,
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.nextTimeLabel,
    required this.scheduledTime,
  });

  final int medicineId;
  final String medicineName;
  final String dosage;
  final String nextTimeLabel;
  final String scheduledTime;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 4,
            width: 48,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor,
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          const SizedBox(height: 16),
          Text(medicineName, style: textTheme.headlineSmall),
          const SizedBox(height: 6),
          Text(dosage, style: textTheme.bodyMedium),
          const SizedBox(height: 16),
          Row(
            children: [
              _ActionButton(
                label: statusLabel(l10n, LogStatus.taken),
                color: AppColors.success,
                icon: Icons.check_circle_outline,
                onTap: () => _logAndClose(context, LogStatus.taken),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: statusLabel(l10n, LogStatus.missed),
                color: AppColors.warning,
                icon: Icons.close_rounded,
                onTap: () => _logAndClose(context, LogStatus.missed),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(l10n.snoozeLabel, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: [
              _SnoozeChip(
                label: l10n.snooze15,
                onTap: () => _snooze(context, 15),
              ),
              _SnoozeChip(
                label: l10n.snooze30,
                onTap: () => _snooze(context, 30),
              ),
              _SnoozeChip(
                label: l10n.snooze60,
                onTap: () => _snooze(context, 60),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(l10n.nextReminder(nextTimeLabel), style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _snooze(BuildContext context, int minutes) async {
    final l10n = context.l10n;
    await NotificationService.instance.scheduleSnooze(
      medicineId: medicineId,
      title: medicineName,
      body: l10n.timeToTake(dosage),
      minutes: minutes,
    );
    await _addLog(LogStatus.snoozed);
    if (context.mounted) {
      Get.back();
      showAppSnackbar(
        message: l10n.snackSnoozed(minutes),
        backgroundColor: AppColors.snoozed,
        icon: Icons.snooze,
      );
    }
  }

  Future<void> _logAndClose(BuildContext context, String status) async {
    final l10n = context.l10n;
    await _addLog(status);
    if (context.mounted) {
      Get.back();
      showAppSnackbar(
        message: status == LogStatus.taken
            ? l10n.snackMarkedTaken
            : l10n.snackMarkedMissed,
        backgroundColor: status == LogStatus.taken
            ? AppColors.sage
            : AppColors.warning,
        icon: status == LogStatus.taken
            ? Icons.check_circle_outline
            : Icons.close_rounded,
      );
    }
  }

  Future<void> _addLog(String status) async {
    final controller = Get.find<LogController>();
    await controller.addLog(
      MedicineLog(
        medicineId: medicineId,
        scheduledTime: scheduledTime,
        status: status,
        date: DateTime.now(),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

class _SnoozeChip extends StatelessWidget {
  const _SnoozeChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(label, style: Theme.of(context).textTheme.labelLarge),
      ),
    );
  }
}
