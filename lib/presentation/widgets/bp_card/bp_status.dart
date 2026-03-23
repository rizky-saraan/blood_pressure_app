import 'package:flutter/material.dart';

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
