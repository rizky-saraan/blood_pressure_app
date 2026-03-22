# 🩺 Blood Pressure Tracker

Aplikasi mobile untuk memantau tekanan darah harian, dibangun dengan **Flutter** menggunakan arsitektur **BLoC** dan penyimpanan lokal **Hive**.

---

## ✨ Fitur

- **Catat tekanan darah** dengan 3 kali pengukuran per sesi
- **Rata-rata otomatis** sistolik dan diastolik dari 3 pengukuran
- **Klasifikasi status** tekanan darah secara otomatis:
  - 🟢 Normal
  - 🟡 Elevated
  - 🟠 Hipertensi Tingkat 1
  - 🔴 Hipertensi Tingkat 2
  - 🟣 Krisis Hipertensi
- **Catat informasi tambahan**: nadi (bpm), kondisi, dan aktivitas sebelum pengukuran
- **Edit & hapus** data yang sudah tersimpan
- **Penyimpanan lokal** — data tersimpan di perangkat tanpa perlu internet

---

## 🛠️ Tech Stack

| Layer | Library |
|---|---|
| UI | Flutter |
| State Management | `flutter_bloc` |
| Penyimpanan Lokal | `hive` + `hive_flutter` |
| Code Generation | `build_runner` + `hive_generator` |

---

## 📁 Struktur Project

```
lib/
├── core/
│   └── utils/
│       └── helper.dart          # Fungsi utilitas (rata-rata, dll)
├── data/
│   ├── datasource/
│   │   └── hive_service.dart    # CRUD operasi Hive
│   └── models/
│       ├── blood_pressure_model.dart
│       └── blood_pressure_model.g.dart
└── presentation/
    ├── bloc/
    │   └── bp_bloc.dart         # Events, States, Bloc
    ├── pages/
    │   ├── add_page.dart        # Form tambah data
    │   └── edit_page.dart       # Form edit data
    └── widgets/
        └── bp_card.dart         # Card item daftar
```

---

## 🚀 Cara Menjalankan

### 1. Clone repository

```bash
git clone https://github.com/username/blood-pressure-tracker.git
cd blood-pressure-tracker
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Generate Hive adapter

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Jalankan aplikasi

```bash
flutter run
```

---

## 📦 Dependencies

Tambahkan ke `pubspec.yaml`:

```yaml
dependencies:
  flutter_bloc: ^8.1.6
  hive: ^2.2.3
  hive_flutter: ^1.1.0

dev_dependencies:
  hive_generator: ^2.0.1
  build_runner: ^2.4.9
```

---

## 🗃️ Model Data

```dart
BloodPressureModel {
  tanggal       // Tanggal pengukuran
  jam           // Jam pengukuran
  sistolik1-3   // Nilai sistolik pengukuran 1, 2, 3
  diastolik1-3  // Nilai diastolik pengukuran 1, 2, 3
  rataSistolik  // Rata-rata sistolik
  rataDiastolik // Rata-rata diastolik
  nadi          // Denyut nadi (bpm)
  kondisi       // Kondisi saat pengukuran
  aktivitas     // Aktivitas sebelum pengukuran
}
```

---

## 📊 Klasifikasi Tekanan Darah

Berdasarkan standar **AHA (American Heart Association)**:

| Status | Sistolik | Diastolik |
|---|---|---|
| Normal | < 120 | < 80 |
| Elevated | 120–129 | < 80 |
| Hipertensi Tingkat 1 | 130–139 | 80–89 |
| Hipertensi Tingkat 2 | ≥ 140 | ≥ 90 |
| Krisis Hipertensi | ≥ 180 | ≥ 120 |

---

## 📝 Alur Penggunaan

1. Buka aplikasi → daftar riwayat pengukuran ditampilkan
2. Tap **tombol tambah** → isi form 3 pengukuran + informasi tambahan → **Simpan**
3. Tap **card** mana saja → langsung masuk halaman edit
4. Tap **ikon hapus** (🗑️) di banner card → data terhapus

---

## 📄 Lisensi

```
MIT License — bebas digunakan dan dimodifikasi.
```
