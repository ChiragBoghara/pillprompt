import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/log_controller.dart';
import '../../data/models/medicine_log.dart';
import '../../services/notification_service.dart';

class ReminderActionModal extends StatelessWidget {
  const ReminderActionModal({
    super.key,
    required this.medicineId,
    required this.medicineName,
    required this.dosage,
    required this.nextTime,
  });

  final int medicineId;
  final String medicineName;
  final String dosage;
  final String nextTime;

  @override
  Widget build(BuildContext context) {
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
                label: 'Taken',
                color: AppColors.success,
                icon: Icons.check_circle_outline,
                onTap: () => _logAndClose(context, 'Taken'),
              ),
              const SizedBox(width: 12),
              _ActionButton(
                label: 'Missed',
                color: AppColors.warning,
                icon: Icons.close_rounded,
                onTap: () => _logAndClose(context, 'Missed'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Snooze', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 10,
            children: [
              _SnoozeChip(label: '15 min', onTap: () => _snooze(context, 15)),
              _SnoozeChip(label: '30 min', onTap: () => _snooze(context, 30)),
              _SnoozeChip(label: '1 hour', onTap: () => _snooze(context, 60)),
            ],
          ),
          const SizedBox(height: 16),
          Text('Next reminder: $nextTime', style: textTheme.bodyMedium),
        ],
      ),
    );
  }

  Future<void> _snooze(BuildContext context, int minutes) async {
    await NotificationService.instance.scheduleSnooze(
      medicineId: medicineId,
      title: medicineName,
      body: 'Time to take $dosage',
      minutes: minutes,
    );
    await _addLog('Snoozed');
    if (context.mounted) Get.back();
  }

  Future<void> _logAndClose(BuildContext context, String status) async {
    await _addLog(status);
    if (context.mounted) Get.back();
  }

  Future<void> _addLog(String status) async {
    final controller = Get.find<LogController>();
    await controller.addLog(MedicineLog(
      medicineId: medicineId,
      scheduledTime: nextTime,
      status: status,
      date: DateTime.now(),
    ));
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
