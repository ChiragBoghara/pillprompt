import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/log_controller.dart';
import '../../controllers/medicine_controller.dart';
import '../../data/models/medicine_log_entry.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final _dateFormat = DateFormat('MMM d, yyyy');
  int? _selectedMedicineId;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final logController = Get.find<LogController>();
    final medicineController = Get.find<MedicineController>();

    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text('Medication history', style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text('Filter by medicine or date range.', style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            Obx(() {
              final medicines = medicineController.medicines.toList();
              return Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      initialValue: _selectedMedicineId,
                      decoration: const InputDecoration(labelText: 'Medicine'),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('All medicines'),
                        ),
                        ...medicines.map(
                          (medicine) => DropdownMenuItem<int?>(
                            value: medicine.id,
                            child: Text(medicine.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => setState(() => _selectedMedicineId = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateRangeField(
                      label: 'Date range',
                      value: _dateRangeLabel(),
                      onTap: () => _pickDateRange(context),
                      onClear: _dateRange == null ? null : () => setState(() => _dateRange = null),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 20),
            Obx(() {
              if (logController.isLoading.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final logs = _applyFilters(logController.logs);
              if (logs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Text(
                    'No history found for the selected filters.',
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final items = _mapLogEntries(logs);
              return Column(
                children: items.map((item) => _HistoryCard(item: item)).toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _dateRangeLabel() {
    if (_dateRange == null) return 'All dates';
    return '${_dateFormat.format(_dateRange!.start)} - ${_dateFormat.format(_dateRange!.end)}';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = _dateRange ??
        DateTimeRange(
          start: now.subtract(const Duration(days: 7)),
          end: now,
        );
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initialRange,
    );
    if (range != null) {
      setState(() => _dateRange = range);
    }
  }

  List<MedicineLogEntry> _applyFilters(List<MedicineLogEntry> logs) {
    return logs.where((log) {
      final matchesMedicine =
          _selectedMedicineId == null || log.medicineId == _selectedMedicineId;
      final matchesRange = _dateRange == null ||
          (log.date.isAfter(_dateRange!.start.subtract(const Duration(days: 1))) &&
              log.date.isBefore(_dateRange!.end.add(const Duration(days: 1))));
      return matchesMedicine && matchesRange;
    }).toList();
  }
}

class _DateRangeField extends StatelessWidget {
  const _DateRangeField({
    required this.label,
    required this.value,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String value;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          suffixIcon: onClear == null
              ? const Icon(Icons.calendar_today_outlined, size: 18)
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: onClear,
                ),
        ),
        child: Text(value, style: Theme.of(context).textTheme.bodyLarge),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.item});

  final _HistoryItem item;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final color = _statusColor(item.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.medication_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: textTheme.titleMedium),
                const SizedBox(height: 4),
                Text('${item.time} · ${item.dosage}', style: textTheme.bodyMedium),
              ],
            ),
          ),
          Text(item.status, style: textTheme.labelLarge?.copyWith(color: color)),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Taken':
        return AppColors.success;
      case 'Missed':
        return AppColors.warning;
      case 'Snoozed':
        return AppColors.snoozed;
      default:
        return AppColors.sage;
    }
  }
}

class _HistoryItem {
  final String name;
  final String time;
  final String dosage;
  final String status;

  const _HistoryItem({
    required this.name,
    required this.time,
    required this.dosage,
    required this.status,
  });
}

List<_HistoryItem> _mapLogEntries(List<MedicineLogEntry> entries) {
  final formatter = DateFormat('MMM d • h:mm a');
  return entries
      .map<_HistoryItem>(
        (entry) => _HistoryItem(
          name: entry.medicineName,
          time: formatter.format(entry.date),
          dosage: entry.dosage,
          status: entry.status,
        ),
      )
      .toList();
}
