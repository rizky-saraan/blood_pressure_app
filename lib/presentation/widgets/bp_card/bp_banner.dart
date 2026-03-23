import 'package:flutter/material.dart';
import 'bp_status.dart';

class BPBanner extends StatelessWidget {
  final BPStatus status;
  final VoidCallback onDelete;

  const BPBanner({
    super.key,
    required this.status,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
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
    );
  }
}
