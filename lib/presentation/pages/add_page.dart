import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/utils/helper.dart';
import '../../data/models/blood_pressure_model.dart';
import '../bloc/bp_bloc.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _formKey = GlobalKey<FormState>();

  final s1 = TextEditingController();
  final d1 = TextEditingController();
  final s2 = TextEditingController();
  final d2 = TextEditingController();
  final s3 = TextEditingController();
  final d3 = TextEditingController();
  final nadiController = TextEditingController();
  final aktivitasController = TextEditingController();

  String _kondisi = 'Sebelum Tidur';

  final List<String> _kondisiOptions = [
    'Sebelum Tidur',
    'Bangun Tidur',
    'Habis Makan',
    'Sedang Pusing',
    'Lemas',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text("Tambah Data"),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _sectionTitle("Pengukuran 1"),
              _rowInput(s1, d1),
              _sectionTitle("Pengukuran 2"),
              _rowInput(s2, d2),
              _sectionTitle("Pengukuran 3"),
              _rowInput(s3, d3),
              _sectionTitle("Informasi Tambahan"),
              _modernInput(
                controller: nadiController,
                label: "Nadi (bpm)",
                icon: Icons.monitor_heart_outlined,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Nadi wajib diisi';
                  final n = int.tryParse(val);
                  if (n == null || n <= 0) return 'Masukkan angka yang valid';
                  return null;
                },
              ),
              _kondisiDropdown(),
              _modernInput(
                controller: aktivitasController,
                label: "Aktivitas Sebelum Pengukuran",
                icon: Icons.directions_run,
                keyboardType: TextInputType.text,
                validator: (val) {
                  if (val == null || val.isEmpty)
                    return 'Aktivitas wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 24),
              _saveButton(context),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    s1.dispose();
    d1.dispose();
    s2.dispose();
    d2.dispose();
    s3.dispose();
    d3.dispose();
    nadiController.dispose();
    aktivitasController.dispose();
    super.dispose();
  }

  Widget _kondisiDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: DropdownButtonFormField<String>(
        initialValue: _kondisi,
        decoration: const InputDecoration(
          prefixIcon: Icon(Icons.medical_services_outlined, color: Colors.grey),
          labelText: "Kondisi",
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 4),
        ),
        borderRadius: BorderRadius.circular(16),
        items: _kondisiOptions
            .map((k) => DropdownMenuItem(value: k, child: Text(k)))
            .toList(),
        onChanged: (val) {
          if (val != null) setState(() => _kondisi = val);
        },
      ),
    );
  }

  Widget _modernInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
        ),
      ),
    );
  }

  Widget _rowInput(
      TextEditingController sistolik, TextEditingController diastolik) {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: sistolik,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Wajib diisi';
                if (int.tryParse(val) == null) return 'Angka saja';
                return null;
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.favorite, color: Colors.grey),
                labelText: "Sistolik",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            child: TextFormField(
              controller: diastolik,
              keyboardType: TextInputType.number,
              validator: (val) {
                if (val == null || val.isEmpty) return 'Wajib diisi';
                if (int.tryParse(val) == null) return 'Angka saja';
                return null;
              },
              decoration: InputDecoration(
                prefixIcon:
                    const Icon(Icons.favorite_border, color: Colors.grey),
                labelText: "Diastolik",
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
                errorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Colors.red, width: 1.5),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _saveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: () {
          if (!_formKey.currentState!.validate()) return;

          final data = BloodPressureModel(
            tanggal: DateTime.now().toString().split(' ')[0],
            jam: formatJam(),
            sistolik1: int.parse(s1.text),
            diastolik1: int.parse(d1.text),
            sistolik2: int.parse(s2.text),
            diastolik2: int.parse(d2.text),
            sistolik3: int.parse(s3.text),
            diastolik3: int.parse(d3.text),
            rataSistolik: rata([
              int.parse(s1.text),
              int.parse(s2.text),
              int.parse(s3.text),
            ]),
            rataDiastolik: rata([
              int.parse(d1.text),
              int.parse(d2.text),
              int.parse(d3.text),
            ]),
            nadi: int.parse(nadiController.text),
            kondisi: _kondisi,
            aktivitas: aktivitasController.text.trim(),
          );

          context.read<BPBloc>().add(AddBP(data));
          Navigator.pop(context);
        },
        child: const Text(
          "Simpan",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }

  // ================= UI COMPONENTS =================

  Widget _sectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 16),
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
