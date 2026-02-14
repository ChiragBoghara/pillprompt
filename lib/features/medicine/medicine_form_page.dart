import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/medicine_controller.dart';
import '../../core/helpers/date_time_helpers.dart';
import '../../data/models/medicine.dart';

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
  String _frequency = 'Daily';
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
      _dosageController.text = _editing!.dosage;
      _frequency = _editing!.frequency;
      _times = List.of(_editing!.times);
      _days = List.of(_editing!.days);
      _startDate = _editing!.startDate;
      _endDate = _editing!.endDate;
      _beforeFood = _editing!.beforeFood;
      _isActive = _editing!.isActive;
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
    final textTheme = Theme.of(context).textTheme;
    final isEdit = _editing != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Medicine' : 'Add Medicine')),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Text(
                isEdit ? 'Update details' : 'Medicine details',
                style: textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine name',
                  hintText: 'e.g., Metformin',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Name is required'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dosageController,
                decoration: const InputDecoration(
                  labelText: 'Dosage',
                  hintText: 'e.g., 500 mg',
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Dosage is required'
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _frequency,
                items: const [
                  DropdownMenuItem(value: 'Daily', child: Text('Daily')),
                  DropdownMenuItem(
                    value: 'Specific Days',
                    child: Text('Specific Days'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() {
                    _frequency = value;
                    if (_frequency == 'Daily') {
                      _days = [];
                    }
                  });
                },
                decoration: const InputDecoration(labelText: 'Frequency'),
              ),
              if (_frequency == 'Specific Days') ...[
                const SizedBox(height: 12),
                Text('Days', style: textTheme.titleMedium),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: _weekdayChips()),
              ],
              const SizedBox(height: 16),
              Text('Times', style: textTheme.titleMedium),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ..._times.map(
                    (time) => InputChip(
                      label: Text(DateTimeHelpers.formatTimeOfDay(time)),
                      onDeleted: () => _removeTime(time),
                    ),
                  ),
                  ActionChip(
                    label: const Text('Add time'),
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
                    color: Colors.redAccent,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _DateField(
                      label: 'Start date',
                      date: _startDate,
                      onTap: () => _pickDate(isStart: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _DateField(
                      label: 'End date (optional)',
                      date: _endDate,
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
                    color: Colors.redAccent,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Before food'),
                value: _beforeFood,
                onChanged: (value) => setState(() => _beforeFood = value),
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Active'),
                subtitle: const Text(
                  'Turn off to pause reminders without deleting this medicine',
                  style: TextStyle(fontSize: 12),
                ),
                value: _isActive,
                onChanged: (value) => setState(() => _isActive = value),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                child: Text(isEdit ? 'Save Changes' : 'Save Medicine'),
              ),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Cancel'),
              ),
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
    ))
      return;
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
    final isValid = _formKey.currentState?.validate() ?? false;
    if (_frequency == 'Specific Days' && _days.isEmpty) {
      setState(() => _timesError = 'Select at least one day');
      return;
    }
    if (_times.isEmpty) {
      setState(() => _timesError = 'Select at least one time');
      return;
    }
    if (_startDate == null) {
      setState(() => _dateError = 'Start date is required');
      return;
    }
    if (_endDate != null && _endDate!.isBefore(_startDate!)) {
      setState(() => _dateError = 'End date must be after the start date');
      return;
    }
    if (!isValid) return;

    final medicine = Medicine(
      id: _editing?.id,
      name: _nameController.text.trim(),
      dosage: _dosageController.text.trim(),
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
    }
  }

  List<Widget> _weekdayChips() {
    const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return List.generate(labels.length, (index) {
      final dayValue = index + 1;
      final selected = _days.contains(dayValue);
      return FilterChip(
        label: Text(labels[index]),
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
    required this.onTap,
  });

  final String label;
  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: InputDecorator(
        decoration: InputDecoration(labelText: label),
        child: Text(
          date == null ? 'Select date' : DateTimeHelpers.formatDate(date!),
        ),
      ),
    );
  }
}
