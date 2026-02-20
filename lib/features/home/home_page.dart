import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillprompt/l10n/app_localizations.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../controllers/medicine_controller.dart';
import '../../controllers/log_controller.dart';
import '../../core/constants/domain_constants.dart';
import '../../core/helpers/date_time_helpers.dart';
import '../../core/helpers/localization_helpers.dart';
import '../../core/helpers/snackbar_helpers.dart';
import '../../data/models/medicine_log_entry.dart';
import '../../data/models/medicine.dart';
import '../../l10n/l10n.dart';
import '../reminder/reminder_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final l10n = context.l10n;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final today = DateFormat('EEEE, MMM d', localeTag).format(DateTime.now());
    final medicineController = Get.find<MedicineController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.todayTitle),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.history),
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: l10n.historyTooltip,
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.settingsTooltip,
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.medicineForm),
        icon: const Icon(Icons.add),
        label: Text(l10n.addMedicine),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await Future.wait([
              medicineController.loadMedicines(),
              Get.find<LogController>().loadLogs(),
            ]);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Text(today, style: textTheme.bodyMedium),
              const SizedBox(height: 12),
              Text(l10n.todaysMedicines, style: textTheme.headlineSmall),
              const SizedBox(height: 16),
              Obx(() {
                final medicines = medicineController.medicines.toList();
                return _WeekPreview(
                  medicines: medicines,
                  localeTag: localeTag,
                  l10n: l10n,
                );
              }),
              const SizedBox(height: 20),
              Obx(() {
                final logController = Get.find<LogController>();
                final medicines = medicineController.medicines.toList();
                final logs = logController.logs.toList();
                if (medicines.isEmpty) {
                  return _EmptyState(
                    onAdd: () => Get.toNamed(AppRoutes.medicineForm),
                    l10n: l10n,
                  );
                }
                return Column(
                  children: medicines
                      .map(
                        (medicine) => _MedicineCard(
                          medicine: medicine,
                          logs: logs,
                          l10n: l10n,
                          localeTag: localeTag,
                        ),
                      )
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({
    required this.medicine,
    required this.logs,
    required this.l10n,
    required this.localeTag,
  });

  final Medicine medicine;
  final List<MedicineLogEntry> logs;
  final AppLocalizations l10n;
  final String localeTag;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstTimeLabel = medicine.times.isNotEmpty
        ? DateTimeHelpers.formatTimeOfDay(
            medicine.times.first,
            locale: localeTag,
          )
        : '--';
    final firstTimeValue = medicine.times.isNotEmpty
        ? DateTimeHelpers.formatTimeForStorage(medicine.times.first)
        : '';

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          builder: (_) => SafeArea(
            child: ReminderActionModal(
              medicineId: medicine.id ?? 0,
              medicineName: medicine.name,
              dosage: medicine.dosage,
              nextTimeLabel: firstTimeLabel,
              scheduledTime: firstTimeValue,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.medication_outlined,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(medicine.name, style: textTheme.titleMedium),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'edit') {
                      Get.toNamed(AppRoutes.medicineForm, arguments: medicine);
                    } else if (value == 'delete') {
                      _confirmDelete(context, medicine);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(value: 'edit', child: Text(l10n.edit)),
                    PopupMenuItem(value: 'delete', child: Text(l10n.delete)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${medicine.dosage} - ${frequencyLabel(l10n, medicine.frequency)}',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            ..._buildTimeRows(context, medicine),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TagChip(
                  label: medicine.beforeFood ? l10n.beforeFood : l10n.afterFood,
                ),
                if (medicine.isActive) _TagChip(label: l10n.active),
                if (medicine.frequency == MedicineFrequency.specificDays &&
                    medicine.days.isNotEmpty)
                  _TagChip(label: _daysLabel(medicine.days, localeTag)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeRows(BuildContext context, Medicine medicine) {
    if (medicine.times.isEmpty) {
      return [
        Row(
          children: [
            const Icon(Icons.access_time, size: 18),
            const SizedBox(width: 6),
            Text('--', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ];
    }

    return medicine.times.map((time) {
      final label = DateTimeHelpers.formatTimeOfDay(time, locale: localeTag);
      final status = _statusForTime(logs, medicine.id, time);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            _StatusChip(
              status: status,
              l10n: l10n,
              isPaused: !medicine.isActive,
            ),
          ],
        ),
      );
    }).toList();
  }

  Future<void> _confirmDelete(BuildContext context, Medicine medicine) async {
    final controller = Get.find<MedicineController>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteMedicineTitle),
        content: Text(l10n.deleteMedicineContent),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteMedicine(medicine.id ?? 0);
      showAppSnackbar(
        message: l10n.snackMedicineDeleted,
        backgroundColor: AppColors.warning,
        icon: Icons.delete_outline,
      );
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.status,
    required this.l10n,
    required this.isPaused,
  });

  final String status;
  final AppLocalizations l10n;
  final bool isPaused;

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;

    if (isPaused) {
      color = Theme.of(context).colorScheme.primary;
      label = l10n.paused;
    } else {
      switch (LogStatus.normalize(status)) {
        case LogStatus.taken:
          color = AppColors.success;
          label = statusLabel(l10n, status);
          break;
        case LogStatus.missed:
          color = AppColors.warning;
          label = statusLabel(l10n, status);
          break;
        case LogStatus.snoozed:
          color = AppColors.snoozed;
          label = statusLabel(l10n, status);
          break;
        default:
          color = Theme.of(context).colorScheme.primary;
          label = l10n.upcoming;
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(color: color),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).dividerColor.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(label, style: Theme.of(context).textTheme.labelMedium),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAdd, required this.l10n});

  final VoidCallback onAdd;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 42,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Text(l10n.noMedicinesYet, style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            l10n.addFirstMedicine,
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onAdd, child: Text(l10n.addMedicine)),
        ],
      ),
    );
  }
}

String _statusForTime(
  List<MedicineLogEntry> logs,
  int? medicineId,
  TimeOfDay time,
) {
  if (medicineId == null) return 'upcoming';
  final stored = DateTimeHelpers.formatTimeForStorage(time);
  final today = DateTime.now();
  final match = logs.firstWhereOrNull((log) {
    final date = log.date;
    return log.medicineId == medicineId &&
        log.scheduledTime == stored &&
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  });
  if (match == null) return 'upcoming';
  return match.status;
}

String _daysLabel(List<int> days, String localeTag) {
  final names = days
      .map((d) => DateTimeHelpers.weekdayShortName(d, locale: localeTag))
      .toList();
  return names.join(', ');
}

class _WeekPreview extends StatelessWidget {
  const _WeekPreview({
    required this.medicines,
    required this.localeTag,
    required this.l10n,
  });

  final List<Medicine> medicines;
  final String localeTag;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    if (medicines.isEmpty) {
      return const SizedBox.shrink();
    }
    final now = DateTime.now();
    final days = List.generate(7, (index) => now.add(Duration(days: index)));

    return SizedBox(
      height: 120,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        separatorBuilder: (_, index) => const SizedBox(width: 12),
        itemBuilder: (_, index) {
          final date = days[index];
          final count = _doseCountForDay(medicines, date);
          final isToday = index == 0;
          return Container(
            width: 120,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: isToday
                  ? Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.12)
                  : Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('EEE', localeTag).format(date),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.dosesCount(count),
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

int _doseCountForDay(List<Medicine> medicines, DateTime date) {
  int count = 0;
  for (final medicine in medicines) {
    if (!medicine.isActive) continue;
    if (date.isBefore(medicine.startDate)) continue;
    if (medicine.endDate != null && date.isAfter(medicine.endDate!)) continue;

    if (medicine.frequency == MedicineFrequency.specificDays &&
        medicine.days.isNotEmpty) {
      if (!medicine.days.contains(date.weekday)) continue;
    }
    count += medicine.times.length;
  }
  return count;
}
