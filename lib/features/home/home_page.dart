import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/routes/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../controllers/medicine_controller.dart';
import '../../controllers/log_controller.dart';
import '../../data/models/medicine_log_entry.dart';
import '../../core/helpers/date_time_helpers.dart';
import '../../data/models/medicine.dart';
import '../reminder/reminder_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final today = DateFormat('EEEE, MMM d').format(DateTime.now());
    final medicineController = Get.find<MedicineController>();
    final logController = Get.find<LogController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today'),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.history),
            icon: const Icon(Icons.calendar_month_outlined),
            tooltip: 'History',
          ),
          IconButton(
            onPressed: () => Get.toNamed(AppRoutes.settings),
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Get.toNamed(AppRoutes.medicineForm),
        icon: const Icon(Icons.add),
        label: const Text('Add Medicine'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(today, style: textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text("Today's Medicines", style: textTheme.headlineSmall),
            const SizedBox(height: 16),
            Obx(() {
              final medicines = medicineController.medicines.toList();
              return _WeekPreview(medicines: medicines);
            }),
            const SizedBox(height: 20),
            Obx(() {
              final medicines = medicineController.medicines.toList();
              final logs = logController.logs.toList();
              if (medicines.isEmpty) {
                return _EmptyState(
                  onAdd: () => Get.toNamed(AppRoutes.medicineForm),
                );
              }
              return Column(
                children: medicines
                    .map(
                      (medicine) => _MedicineCard(
                        medicine: medicine,
                        status: _latestStatusForToday(logs, medicine.id),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  const _MedicineCard({required this.medicine, required this.status});

  final Medicine medicine;
  final String status;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final firstTime = medicine.times.isNotEmpty
        ? DateTimeHelpers.formatTimeOfDay(medicine.times.first)
        : '--';

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
              nextTime: firstTime,
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
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${medicine.dosage} · ${medicine.frequency}',
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
                  label: medicine.beforeFood ? 'Before Food' : 'After Food',
                ),
                if (medicine.isActive) _TagChip(label: 'Active'),
                if (medicine.frequency == 'Specific Days' &&
                    medicine.days.isNotEmpty)
                  _TagChip(label: _daysLabel(medicine.days)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeRows(BuildContext context, Medicine medicine) {
    final logController = Get.find<LogController>();
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
      final label = DateTimeHelpers.formatTimeOfDay(time);
      final status = _statusForTime(logController.logs, medicine.id, label);
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          children: [
            const Icon(Icons.access_time, size: 18),
            const SizedBox(width: 6),
            Text(label, style: Theme.of(context).textTheme.bodyLarge),
            const Spacer(),
            _StatusChip(status: medicine.isActive ? status : 'Paused'),
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
        title: const Text('Delete medicine?'),
        content: const Text('This will remove the medicine and its reminders.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await controller.deleteMedicine(medicine.id ?? 0);
    }
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (status) {
      case 'Taken':
        color = AppColors.success;
        break;
      case 'Missed':
        color = AppColors.warning;
        break;
      case 'Snoozed':
        color = AppColors.snoozed;
        break;
      default:
        color = Theme.of(context).colorScheme.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        status,
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
  const _EmptyState({required this.onAdd});

  final VoidCallback onAdd;

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
          Text('No medicines yet', style: textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Add your first medicine to get started.',
            style: textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onAdd, child: const Text('Add Medicine')),
        ],
      ),
    );
  }
}

String _latestStatusForToday(List<MedicineLogEntry> logs, int? medicineId) {
  if (medicineId == null) return 'Upcoming';
  final today = DateTime.now();
  final match = logs.firstWhereOrNull((log) {
    final date = log.date;
    return log.medicineId == medicineId &&
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  });
  if (match == null) return 'Upcoming';
  return match.status;
}

String _statusForTime(
  List<MedicineLogEntry> logs,
  int? medicineId,
  String timeLabel,
) {
  if (medicineId == null) return 'Upcoming';
  final today = DateTime.now();
  final match = logs.firstWhereOrNull((log) {
    final date = log.date;
    return log.medicineId == medicineId &&
        log.scheduledTime == timeLabel &&
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day;
  });
  if (match == null) return 'Upcoming';
  return match.status;
}

String _daysLabel(List<int> days) {
  const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  final names = days.map((d) => labels[d - 1]).toList();
  return names.join(', ');
}

class _WeekPreview extends StatelessWidget {
  const _WeekPreview({required this.medicines});

  final List<Medicine> medicines;

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
                  DateFormat('EEE').format(date),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '${date.day}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  '$count doses',
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

    if (medicine.frequency == 'Specific Days' && medicine.days.isNotEmpty) {
      if (!medicine.days.contains(date.weekday)) continue;
    }
    count += medicine.times.length;
  }
  return count;
}
