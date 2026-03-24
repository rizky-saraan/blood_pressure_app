import 'package:hive_flutter/hive_flutter.dart';
import '../models/blood_pressure_model.dart';

class HiveService {
  Box<BloodPressureModel> get box {
    final settingsBox = Hive.box('settings_box');
    final active = settingsBox.get('active_profile', defaultValue: 'Saya');
    return Hive.box<BloodPressureModel>('bp_box_$active');
  }

  Future<void> add(BloodPressureModel data) async {
    await box.add(data);
  }

  Future<void> delete(BloodPressureModel data) async {
    await data.delete();
  }

  Future<void> edit(
      BloodPressureModel oldData, BloodPressureModel newData) async {
    await box.put(oldData.key, newData);
  }

  List<BloodPressureModel> getAll() => box.values.toList().reversed.toList();

  List<BloodPressureModel> getPaginated(int offset, int limit) {
    final total = box.length;
    List<BloodPressureModel> result = [];
    for (int i = 0; i < limit; i++) {
      int index = total - 1 - offset - i;
      if (index < 0) break;
      result.add(box.getAt(index)!);
    }
    return result;
  }
}
