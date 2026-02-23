import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../data/models/medicine_log.dart';
import '../data/models/medicine_log_entry.dart';
import '../data/repositories/medicine_log_repository.dart';

class LogController extends GetxController with WidgetsBindingObserver {
  LogController({required MedicineLogRepository repository})
    : _repository = repository;

  final MedicineLogRepository _repository;

  final logs = <MedicineLogEntry>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onReady() {
    super.onReady();
    loadLogs();
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && !isLoading.value) {
      loadLogs();
    }
  }

  Future<void> loadLogs() async {
    isLoading.value = true;
    logs.value = await _repository.getAllWithMedicine();
    isLoading.value = false;
  }

  Future<void> addLog(MedicineLog log) async {
    await _repository.insert(log);
    await loadLogs();
  }
}
