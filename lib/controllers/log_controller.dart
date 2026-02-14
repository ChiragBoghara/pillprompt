import 'package:get/get.dart';

import '../data/models/medicine_log.dart';
import '../data/models/medicine_log_entry.dart';
import '../data/repositories/medicine_log_repository.dart';

class LogController extends GetxController {
  LogController({required MedicineLogRepository repository}) : _repository = repository;

  final MedicineLogRepository _repository;

  final logs = <MedicineLogEntry>[].obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadLogs();
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
