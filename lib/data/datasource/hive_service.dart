import 'package:hive/hive.dart';

import '../models/blood_pressure_model.dart';

class HiveService {
  final box = Hive.box<BloodPressureModel>('bp_box');

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
}
