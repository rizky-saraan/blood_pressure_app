import 'package:flutter/material.dart';

import '../../../core/utils/helper.dart';
import '../../../data/models/blood_pressure_model.dart';
import 'bp_info_row.dart';
import 'bp_status.dart';

class BPContent extends StatelessWidget {
  final BloodPressureModel data;
  final BPStatus status;

  const BPContent({
    super.key,
    required this.data,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
      child: Row(
        children: [
          // Ikon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: status.color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite,
              color: status.color,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${data.rataSistolik}/${data.rataDiastolik}",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: status.color,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 3),
                      child: Text(
                        "mmHg",
                        style: TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      formatTanggalJam(data.tanggal, data.jam),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                BPInfoRow(
                  icon: Icons.format_list_numbered,
                  label: "Pengukuran",
                  value:
                      "${data.sistolik1}/${data.diastolik1}  •  ${data.sistolik2}/${data.diastolik2}  •  ${data.sistolik3}/${data.diastolik3}",
                ),
                const SizedBox(height: 4),
                BPInfoRow(
                  icon: Icons.monitor_heart_outlined,
                  label: "Nadi",
                  value: "${data.nadi} bpm",
                ),
                const SizedBox(height: 4),
                BPInfoRow(
                  icon: Icons.directions_run,
                  label: "Aktivitas",
                  value: data.aktivitas,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
