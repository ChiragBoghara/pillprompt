import 'package:get/get.dart';

import '../data/models/medicine.dart';
import '../data/repositories/medicine_repository.dart';
import '../services/notification_service.dart';

class MedicineController extends GetxController {
  MedicineController({
    required MedicineRepository repository,
    required NotificationService notificationService,
  })  : _repository = repository,
        _notificationService = notificationService;

  final MedicineRepository _repository;
  final NotificationService _notificationService;

  final medicines = <Medicine>[].obs;
  final isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    loadMedicines();
  }

  Future<void> loadMedicines() async {
    isLoading.value = true;
    medicines.value = await _repository.getAll();
    isLoading.value = false;
  }

  Future<void> addMedicine(Medicine medicine) async {
    final id = await _repository.insert(medicine);
    final saved = medicine.copyWith(id: id);
    medicines.insert(0, saved);
    if (saved.isActive) {
      await _notificationService.scheduleMedicine(saved);
    }
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await _repository.update(medicine);
    final index = medicines.indexWhere((item) => item.id == medicine.id);
    if (index != -1) {
      medicines[index] = medicine;
    }
    await _notificationService.cancelMedicine(medicine);
    if (medicine.isActive) {
      await _notificationService.scheduleMedicine(medicine);
    }
  }

  Future<void> deleteMedicine(int id) async {
    final medicine = medicines.firstWhereOrNull((item) => item.id == id);
    if (medicine != null) {
      await _notificationService.cancelMedicine(medicine);
    }
    await _repository.delete(id);
    medicines.removeWhere((item) => item.id == id);
  }
}
