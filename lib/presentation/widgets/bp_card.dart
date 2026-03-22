import 'package:flutter/material.dart';

import '../../core/utils/helper.dart';
import '../../data/models/blood_pressure_model.dart';

class BPCard extends StatelessWidget {
  final BloodPressureModel data;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const BPCard({
    super.key,
    required this.data,
    required this.onDelete,
    required this.onEdit,
  });

  // ─── Status Logic ───────────────────────────────────────────────
  BPStatus get _status {
    final s = data.rataSistolik;
    final d = data.rataDiastolik;

    if (s >= 180 || d >= 120) return BPStatus.krisisHipertensi;
    if (s >= 140 || d >= 90) return BPStatus.hipertensi2;
    if (s >= 130 || d >= 80) return BPStatus.hipertensi1;
    if (s >= 120 && d < 80) return BPStatus.elevated;
    return BPStatus.normal;
  }

  @override
  Widget build(BuildContext context) {
    final status = _status;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: status.color.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: status.color.withOpacity(0.08),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            // ─── Banner: Status + Edit + Hapus ───────────────────────
            Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: status.color.withOpacity(0.1),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Icon(status.icon, size: 14, color: status.color),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      status.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: status.color,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  // Tombol Hapus
                  SizedBox(
                    width: 32,
                    height: 32,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(
                        Icons.delete_outline,
                        size: 18,
                        color: Colors.red,
                      ),
                      tooltip: 'Hapus',
                      onPressed: onDelete,
                    ),
                  ),

                  const SizedBox(width: 4),
                ],
              ),
            ),

            // ─── Main Content ─────────────────────────────────────────
            Padding(
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
                                style:
                                    TextStyle(fontSize: 11, color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              formatTanggalJam(data.tanggal, data.jam),
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        _infoRow(
                          icon: Icons.format_list_numbered,
                          label: "Pengukuran",
                          value:
                              "${data.sistolik1}/${data.diastolik1}  •  ${data.sistolik2}/${data.diastolik2}  •  ${data.sistolik3}/${data.diastolik3}",
                        ),
                        const SizedBox(height: 4),
                        _infoRow(
                          icon: Icons.monitor_heart_outlined,
                          label: "Nadi",
                          value: "${data.nadi} bpm",
                        ),
                        const SizedBox(height: 4),
                        _infoRow(
                          icon: Icons.directions_run,
                          label: "Aktivitas",
                          value: data.aktivitas,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 5),
        Text(
          "$label: ",
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Status Enum ──────────────────────────────────────────────────────────────
enum BPStatus {
  normal,
  elevated,
  hipertensi1,
  hipertensi2,
  krisisHipertensi,
}

extension BPStatusExtension on BPStatus {
  Color get color {
    switch (this) {
      case BPStatus.normal:
        return const Color(0xFF2E7D32);
      case BPStatus.elevated:
        return const Color(0xFFF9A825);
      case BPStatus.hipertensi1:
        return const Color(0xFFE65100);
      case BPStatus.hipertensi2:
        return const Color(0xFFC62828);
      case BPStatus.krisisHipertensi:
        return const Color(0xFF6A1B9A);
    }
  }

  IconData get icon {
    switch (this) {
      case BPStatus.normal:
        return Icons.check_circle_outline;
      case BPStatus.elevated:
        return Icons.info_outline;
      case BPStatus.hipertensi1:
        return Icons.warning_amber_outlined;
      case BPStatus.hipertensi2:
        return Icons.warning_outlined;
      case BPStatus.krisisHipertensi:
        return Icons.emergency_outlined;
    }
  }

  String get label {
    switch (this) {
      case BPStatus.normal:
        return 'Normal';
      case BPStatus.elevated:
        return 'Elevated';
      case BPStatus.hipertensi1:
        return 'Hipertensi Tingkat 1';
      case BPStatus.hipertensi2:
        return 'Hipertensi Tingkat 2';
      case BPStatus.krisisHipertensi:
        return 'Krisis Hipertensi';
    }
  }
}
