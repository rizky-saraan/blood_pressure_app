import 'package:hive/hive.dart';

part 'blood_pressure_model.g.dart';

@HiveType(typeId: 0)
class BloodPressureModel extends HiveObject {
  @HiveField(0)
  String tanggal;

  @HiveField(1)
  String jam;

  @HiveField(2)
  int sistolik1;

  @HiveField(3)
  int diastolik1;

  @HiveField(4)
  int sistolik2;

  @HiveField(5)
  int diastolik2;

  @HiveField(6)
  int sistolik3;

  @HiveField(7)
  int diastolik3;

  @HiveField(8)
  int rataSistolik;

  @HiveField(9)
  int rataDiastolik;

  @HiveField(10)
  int nadi;

  @HiveField(11)
  String kondisi;

  @HiveField(12)
  String aktivitas;

  BloodPressureModel({
    required this.tanggal,
    required this.jam,
    required this.sistolik1,
    required this.diastolik1,
    required this.sistolik2,
    required this.diastolik2,
    required this.sistolik3,
    required this.diastolik3,
    required this.rataSistolik,
    required this.rataDiastolik,
    required this.nadi,
    required this.kondisi,
    required this.aktivitas,
  });
}
