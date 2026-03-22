import 'package:hive/hive.dart';

import '../models/blood_pressure_model.dart';

class HiveService {
  final box = Hive.box<BloodPressureModel>('bp_box');

  Future<void> add(BloodPressureModel data) async {
    await box.add(data);
  }

  Future<void> delete(int index) async {
    await box.deleteAt(index);
  }

  Future<void> edit(int index, BloodPressureModel newData) async {
    await box.putAt(index, newData);
  }

  List<BloodPressureModel> getAll() => box.values.toList();
}
