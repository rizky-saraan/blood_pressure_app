import 'package:flutter/material.dart';

import '../../../data/models/blood_pressure_model.dart';
import 'bp_banner.dart';
import 'bp_content.dart';
import 'bp_status.dart';

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
            BPBanner(status: status, onDelete: onDelete),

            // ─── Main Content ─────────────────────────────────────────
            BPContent(data: data, status: status),
          ],
        ),
      ),
    );
  }
}
