import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:excel/excel.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';

import '../../data/models/blood_pressure_model.dart';

class ExcelService {
  static Future<void> exportData(List<BloodPressureModel> data, String profileName) async {
    try {
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Data $profileName'];
      // The default sheet is 'Sheet1', let's remove it if we created a new one
      if (excel.getDefaultSheet() != 'Data $profileName') {
        excel.delete('Sheet1');
      }
      excel.setDefaultSheet('Data $profileName');

      // Add Headers
      sheetObject.appendRow([
        TextCellValue('Tanggal'),
        TextCellValue('Jam'),
        TextCellValue('Sistolik 1'),
        TextCellValue('Diastolik 1'),
        TextCellValue('Sistolik 2'),
        TextCellValue('Diastolik 2'),
        TextCellValue('Sistolik 3'),
        TextCellValue('Diastolik 3'),
        TextCellValue('Rata Sistolik'),
        TextCellValue('Rata Diastolik'),
        TextCellValue('Nadi'),
        TextCellValue('Kondisi'),
        TextCellValue('Aktivitas'),
      ]);

      // Add Data Rows
      for (var item in data) {
        sheetObject.appendRow([
          TextCellValue(item.tanggal),
          TextCellValue(item.jam),
          IntCellValue(item.sistolik1),
          IntCellValue(item.diastolik1),
          IntCellValue(item.sistolik2),
          IntCellValue(item.diastolik2),
          IntCellValue(item.sistolik3),
          IntCellValue(item.diastolik3),
          IntCellValue(item.rataSistolik),
          IntCellValue(item.rataDiastolik),
          IntCellValue(item.nadi),
          TextCellValue(item.kondisi),
          TextCellValue(item.aktivitas),
        ]);
      }

      var fileBytes = excel.save();
      if (fileBytes != null) {
        final directory = await getTemporaryDirectory();
        final filePath = '${directory.path}/Riwayat_Tensi_$profileName.xlsx';
        File file = File(filePath);
        await file.writeAsBytes(fileBytes);
        
        await Share.shareXFiles([XFile(filePath)], text: 'Export Data Tekanan Darah ($profileName)');
      }
    } catch (e) {
      debugPrint("Error exporting Excel: $e");
    }
  }
}
