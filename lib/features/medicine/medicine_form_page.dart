import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../controllers/medicine_controller.dart';
import '../../core/constants/domain_constants.dart';
import '../../core/helpers/date_time_helpers.dart';
import '../../core/helpers/snackbar_helpers.dart';
import '../../data/models/medicine.dart';
import '../../l10n/l10n.dart';

class MedicineFormPage extends StatefulWidget {
  const MedicineFormPage({super.key});

  @override
  State<MedicineFormPage> createState() => _MedicineFormPageState();
}

class _MedicineFormPageState extends State<MedicineFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();

  List<TimeOfDay> _times = [];
  String _frequency = MedicineFrequency.daily;
  List<int> _days = [];
  DateTime? _startDate;
  DateTime? _endDate;
  bool _beforeFood = true;
  bool _isActive = true;
  String? _timesError;
  String? _dateError;
  Medicine? _editing;

  @override
  void initState() {
    super.initState();
    _editing = Get.arguments is Medicine ? Get.arguments as Medicine : null;
    if (_editing != null) {
      _nameController.text = _editing!.name;
      _dosageController.text = _editing!.dosage ?? '';
      _frequency = _editing!.frequency;
      _times = List.of(_editing!.times);
      _days = List.of(_editing!.days);
      _startDate = _editing!.startDate;
      _endDate = _editing!.endDate;
      _beforeFood = _editing!.beforeFood;
      _isActive = _editing!.isActive;
    } else {
      final now = DateTime.now();
      _startDate = DateTime(now.year, now.month, now.day);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textTheme = Theme.of(context).textTheme;
    final localeTag = Localizations.localeOf(context).toLanguageTag();
    final isEdit = _editing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEdit ? l10n.medicineFormEditTitle : l10n.medicineFormAddTitle,
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Text(
                isEdit ? l10n.updateDetails : l10n.medicineDetails,
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: l10n.medicineNameLabel,
                  hintText: l10n.medicineNameHint,
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? l10n.nameRequired
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                decoration: InputDecoration(
                  labelText: l10n.dosageLabel,
                  hintText: l10n.dosageHint,
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _frequency,
                items: [
                  DropdownMenuItem(
                    value: MedicineFrequency.daily,
                    child: Text(l10n.frequencyDaily),
                  ),
                  DropdownMenuItem(
                    value: MedicineFrequency.specificDays,
                    child: Text(l10n.frequencySpecificDays),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _frequency = value;
                    if (_frequency == MedicineFrequency.daily) {
                      _days = [];
                    }
                  });
                },
                decoration: InputDecoration(labelText: l10n.frequencyLabel),
              ),
              if (_frequency == MedicineFrequency.specificDays) ...[
                const SizedBox(height: 12),
                Text(l10n.daysLabel, style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _weekdayChips(localeTag),
                ),
              ],
              const SizedBox(height: 16),
              Text(l10n.timesLabel, style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._times.map(
                    (time) => InputChip(
                      label: Text(
                        DateTimeHelpers.formatTimeOfDay(
                          time,
                          locale: localeTag,
                        ),
                      ),
                      onDeleted: () => _removeTime(time),
                    ),
                  ),
                  ActionChip(
                    label: Text(l10n.addTime),
                    avatar: const Icon(Icons.add, size: 18),
                    onPressed: _pickTime,
                  ),
                ],
              ),
              if (_timesError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _timesError!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: l10n.startDateLabel,
                      date: _startDate,
                      localeTag: localeTag,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: l10n.endDateOptionalLabel,
                      date: _endDate,
                      localeTag: localeTag,
                      onTap: () => _pickDate(isStart: false),
                    ),
                  ),
                ],
              ),
              if (_dateError != null) ...[
                const SizedBox(height: 8),
                Text(
                  _dateError!,
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.warning,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.beforeFood),
                value: _beforeFood,
                onChanged: (value) => setState(() => _beforeFood = value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.active),
                subtitle: Text(
                  l10n.pauseHint,
                  style: const TextStyle(fontSize: 12),
                ),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? l10n.saveChanges : l10n.saveMedicine),
              ),
              const SizedBox(height: 8),
              TextButton(onPressed: () => Get.back(), child: Text(l10n.cancel)),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickTime() async {
    final selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (selected == null) return;
    if (_times.any(
      (time) => time.hour == selected.hour && time.minute == selected.minute,
    )) {
      return;
    }
    setState(() {
      _times.add(selected);
      _timesError = null;
    });
  }

  void _removeTime(TimeOfDay time) {
    setState(() {
      _times.removeWhere(
        (item) => item.hour == time.hour && item.minute == time.minute,
      );
    });
  }

  Future<void> _pickDate({required bool isStart}) async {
    final now = DateTime.now();
    final initialDate = isStart
        ? (_startDate ?? now)
        : (_endDate ?? _startDate ?? now);
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );
    if (selected == null) return;
    setState(() {
      if (isStart) {
        _startDate = selected;
      } else {
        _endDate = selected;
      }
      _dateError = null;
    });
  }

  Future<void> _save() async {
    final l10n = context.l10n;
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_frequency == MedicineFrequency.specificDays && _days.isEmpty) {
      setState(() => _timesError = l10n.selectAtLeastOneDay);
      return;
    }
    if (_times.isEmpty) {
      setState(() => _timesError = l10n.selectAtLeastOneTime);
      return;
    }
    if (_startDate == null) {
      setState(() => _dateError = l10n.startDateRequired);
      return;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      setState(() => _dateError = l10n.endDateAfterStart);
      return;
    }
    if (!isValid) return;

    final dosage = _dosageController.text.trim();
    final medicine = Medicine(
      id: _editing?.id,
      name: _nameController.text.trim(),
      dosage: dosage.isEmpty ? null : dosage,
      frequency: _frequency,
      times: _times,
      days: _days,
      startDate: _startDate!,
      endDate: _endDate,
      beforeFood: _beforeFood,
      isActive: _isActive,
    );

    final controller = Get.find<MedicineController>();
    if (_editing == null) {
      await controller.addMedicine(medicine);
    } else {
      await controller.updateMedicine(medicine);
    }

    if (mounted) {
      Get.back();
      showAppSnackbar(
        message: _editing == null
            ? l10n.snackMedicineAdded
            : l10n.snackMedicineUpdated,
        backgroundColor: AppColors.sage,
        icon: Icons.check_circle_outline,
      );
    }
  }

  List<Widget> _weekdayChips(String localeTag) {
    return List.generate(7, (index) {
      final dayValue = index + 1;
      final selected = _days.contains(dayValue);
      return FilterChip(
        label: Text(
          DateTimeHelpers.weekdayShortName(dayValue, locale: localeTag),
        ),
        selected: selected,
        onSelected: (value) {
          setState(() {
            if (value) {
              _days.add(dayValue);
            } else {
              _days.remove(dayValue);
            }
          });
        },
      );
    });
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.date,
    required this.localeTag,
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final String localeTag;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          date == null
              ? l10n.selectDate
              : DateTimeHelpers.formatDate(date!, locale: localeTag),
        ),
      ),
    );
  }
}
