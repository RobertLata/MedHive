import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/medicine.dart';

final medicineListProvider =
    StateNotifierProvider<MedicineNotifier, MedicineState>((ref) {
  return MedicineNotifier();
});

class MedicineNotifier extends StateNotifier<MedicineState> {
  MedicineNotifier() : super(MedicineState(medicines: []));
  void addMedicineToList(Medicine medicine) {
    final newStateList = state.medicines;
    newStateList.add(medicine);
    state = state.copyWith(medicineList: newStateList);
  }

  void incrementMedicinePrice(String medicineName, double increment) {
    var newStateList = state.medicines;

    int index =
        newStateList.indexWhere((medicine) => medicine.name == medicineName);

    if (index != -1) {
      newStateList[index] = newStateList[index]
          .copyWith(price: newStateList[index].price + increment);

      state = state.copyWith(medicineList: newStateList);
    }
  }

  bool checkIfMedicineAlreadyExists(Medicine newMedicine) {
    return state.medicines.any((medicine) => medicine.name == newMedicine.name);
  }

  bool checkIfMedicineIsFromSamePharmacy(Medicine medicine) {
    for (int i = 0; i < state.medicines.length; i++) {
      if (state.medicines[i].id != medicine.id) {
        return false;
      }
    }
    return true;
  }

  void removeMedicineFromList(Medicine medicineToRemove) {
    final newStateList = state.medicines;
    newStateList
        .removeWhere((medicine) => medicine.name == medicineToRemove.name);
    state = state.copyWith(medicineList: newStateList);
  }

  void removeOneMedicineFromList(Medicine medicineToRemove) {
    final newStateList = state.medicines;
    int index = newStateList
        .indexWhere((medicine) => medicine.name == medicineToRemove.name);
    if (index != -1) {
      newStateList.removeAt(index);
    }
    state = state.copyWith(medicineList: newStateList);
  }

  void clearMedicineList() {
    state = state.copyWith(medicineList: []);
  }
}

class MedicineState {
  List<Medicine> medicines;
  MedicineState({required this.medicines});

  MedicineState copyWith({List<Medicine>? medicineList}) {
    return MedicineState(medicines: medicineList ?? medicines);
  }

  int getMedicineDose(Medicine medicine) {
    int medicineLength = 0;
    for (int i = 0; i < medicines.length; i++) {
      if (medicines[i].name == medicine.name) {
        medicineLength++;
      }
    }
    return medicineLength;
  }
}
