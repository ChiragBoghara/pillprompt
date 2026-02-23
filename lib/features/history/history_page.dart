import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pillprompt/l10n/app_localizations.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/log_controller.dart';
import '../../controllers/medicine_controller.dart';
import '../../core/constants/domain_constants.dart';
import '../../core/helpers/localization_helpers.dart';
import '../../data/models/medicine_log_entry.dart';
import '../../l10n/l10n.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  int? _selectedMedicineId;
  DateTimeRange? _dateRange;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final dateFormat = DateFormat.yMMMd(localeTag);
    final logController = Get.find<LogController>();
    final medicineController = Get.find<MedicineController>();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.historyTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Text(l10n.medicationHistory, style: textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(l10n.filterByMedicineOrDateRange, style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            Obx(() {
              final medicines = medicineController.medicines.toList();
              return Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int?>(
                      isExpanded: true,
                      initialValue: _selectedMedicineId,
                      decoration: InputDecoration(
                        labelText: l10n.medicineLabel,
                      ),
                      items: [
                        DropdownMenuItem<int?>(
                          value: null,
                          child: Text(
                            l10n.allMedicines,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        ...medicines.map(
                          (medicine) => DropdownMenuItem<int?>(
                            value: medicine.id,
                            child: Text(
                              medicine.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedMedicineId = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateRangeField(
                      label: l10n.dateRangeLabel,
                      value: _dateRangeLabel(dateFormat, l10n),
                      onTap: () => _pickDateRange(context),
                      onClear: _dateRange == null
                          ? null
                          : () => setState(() => _dateRange = null),
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
                    l10n.noHistoryFound,
                    style: textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                );
              }
              final items = _mapLogEntries(logs, localeTag, l10n);
              return Column(
                children: items
                    .map((item) => _HistoryCard(item: item))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  String _dateRangeLabel(DateFormat dateFormat, AppLocalizations l10n) {
    if (_dateRange == null) return l10n.allDates;
    return '${dateFormat.format(_dateRange!.start)} - ${dateFormat.format(_dateRange!.end)}';
  }

  Future<void> _pickDateRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange =
        _dateRange ??
        DateTimeRange(start: now.subtract(const Duration(days: 7)), end: now);
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
      final matchesRange =
          _dateRange == null ||
          (log.date.isAfter(
                _dateRange!.start.subtract(const Duration(days: 1)),
              ) &&
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
              : IconButton(icon: const Icon(Icons.clear), onPressed: onClear),
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
    final color = _statusColor(item.statusCode);
    final dosage = item.dosage?.trim();
    final subtitle = dosage == null || dosage.isEmpty
        ? item.time
        : '${item.time} - $dosage';

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
                Text(subtitle, style: textTheme.bodyMedium),
              ],
            ),
          ),
          Text(
            item.statusLabel,
            style: textTheme.labelLarge?.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
    switch (LogStatus.normalize(status)) {
      case LogStatus.taken:
        return AppColors.success;
      case LogStatus.missed:
        return AppColors.warning;
      case LogStatus.snoozed:
        return AppColors.snoozed;
      default:
        return AppColors.sage;
    }
  }
}

class _HistoryItem {
  final String name;
  final String time;
  final String? dosage;
  final String statusCode;
  final String statusLabel;

  const _HistoryItem({
    required this.name,
    required this.time,
    required this.dosage,
    required this.statusCode,
    required this.statusLabel,
  });
}

List<_HistoryItem> _mapLogEntries(
  List<MedicineLogEntry> entries,
  String localeTag,
  AppLocalizations l10n,
) {
  final formatter = DateFormat.yMMMd(localeTag).add_jm();
  return entries
      .map<_HistoryItem>(
        (entry) => _HistoryItem(
          name: entry.medicineName,
          time: formatter.format(entry.date),
          dosage: entry.dosage,
          statusCode: entry.status,
          statusLabel: statusLabel(l10n, entry.status),
        ),
      )
      .toList();
}
