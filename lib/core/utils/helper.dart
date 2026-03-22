String formatTanggalJam(String tanggal, String jam) {
  const bulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember'
  ];

  final parts = tanggal.split('-'); // "2026-03-22"
  final hari = parts[2];
  final bln = bulan[int.parse(parts[1])];
  final tahun = parts[0];

  return '$hari $bln $tahun Jam $jam';
}

int rata(List<int> data) {
  return (data.reduce((a, b) => a + b) / data.length).round();
}

String formatJam() {
  final now = DateTime.now();
  final jam = now.hour.toString().padLeft(2, '0');
  final menit = now.minute.toString().padLeft(2, '0');
  return '$jam:$menit';
}
