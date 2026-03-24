import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bp_bloc.dart';
import '../bloc/profile_cubit.dart';
import '../../core/utils/excel_service.dart';
import '../../data/models/blood_pressure_model.dart';

class GraphicPage extends StatefulWidget {
  const GraphicPage({super.key});

  @override
  State<GraphicPage> createState() => _GraphicPageState();
}

class _GraphicPageState extends State<GraphicPage> {
  String _selectedFilter = '7_hari'; // Options: '7_hari', '30_hari', 'kustom', 'semua'
  DateTimeRange? _customDateRange;

  List<BloodPressureModel> _getFilteredData(List<BloodPressureModel> allData) {
    if (_selectedFilter == 'semua') return allData;

    final now = DateTime.now();
    DateTime startDate;
    DateTime endDate = now;

    if (_selectedFilter == '7_hari') {
      startDate = now.subtract(const Duration(days: 7));
    } else if (_selectedFilter == '30_hari') {
      startDate = now.subtract(const Duration(days: 30));
    } else if (_selectedFilter == 'kustom' && _customDateRange != null) {
      startDate = _customDateRange!.start;
      endDate = _customDateRange!.end.add(const Duration(days: 1)); // Include end day
    } else {
      return allData;
    }

    return allData.where((bp) {
      try {
        final bpDate = DateTime.parse(bp.tanggal);
        return bpDate.isAfter(startDate.subtract(const Duration(days: 1))) && 
               bpDate.isBefore(endDate.add(const Duration(days: 1)));
      } catch (e) {
        return true; // Fallback
      }
    }).toList();
  }

  void _showCustomDatePicker() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _customDateRange,
    );
    if (picked != null) {
      setState(() {
        _selectedFilter = 'kustom';
        _customDateRange = picked;
      });
    } else {
      if (_customDateRange == null && _selectedFilter == 'kustom') {
        setState(() {
          _selectedFilter = '7_hari';
        });
      }
    }
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: color.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 8),
              Text(title, style: TextStyle(fontSize: 12, color: color.withValues(alpha: 0.8), fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(value, style: TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
        title: Text(
          "Dashboard Grafik",
          style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download, color: Theme.of(context).appBarTheme.foregroundColor),
            tooltip: 'Export ke Excel',
            onPressed: () async {
              final activeProfile = context.read<ProfileCubit>().state.activeProfile;
              final state = context.read<BPBloc>().state;
              if (state is BPLoaded && state.data.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menyiapkan file Excel..."), duration: Duration(seconds: 1)),
                );
                await ExcelService.exportData(state.data, activeProfile);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Belum ada data untuk di-export")),
                );
              }
            },
          ),
        ],
      ),
      body: BlocBuilder<BPBloc, BPState>(
        builder: (context, state) {
          if (state is BPLoaded) {
            if (state.data.isEmpty) {
              return const Center(child: Text("Belum ada data"));
            }

            final filteredData = _getFilteredData(state.data);
            
            // Calculate Stats
            int avgSys = 0, avgDia = 0, maxSys = 0, maxDia = 0;
            if (filteredData.isNotEmpty) {
              int sumSys = 0, sumDia = 0;
              for (var bp in filteredData) {
                sumSys += bp.rataSistolik;
                sumDia += bp.rataDiastolik;
                if (bp.rataSistolik > maxSys) maxSys = bp.rataSistolik;
                if (bp.rataDiastolik > maxDia) maxDia = bp.rataDiastolik;
              }
              avgSys = (sumSys / filteredData.length).round();
              avgDia = (sumDia / filteredData.length).round();
            }

            // Generate Spots
            List<FlSpot> systolicSpots = [];
            List<FlSpot> diastolicSpots = [];
            for (int i = 0; i < filteredData.length; i++) {
              systolicSpots.add(FlSpot(i.toDouble(), filteredData[i].rataSistolik.toDouble()));
              diastolicSpots.add(FlSpot(i.toDouble(), filteredData[i].rataDiastolik.toDouble()));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Filter Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Filter Data:", style: TextStyle(fontWeight: FontWeight.bold)),
                      DropdownButton<String>(
                        value: _selectedFilter,
                        underline: const SizedBox(),
                        items: const [
                          DropdownMenuItem(value: '7_hari', child: Text("7 Hari Terakhir")),
                          DropdownMenuItem(value: '30_hari', child: Text("30 Hari Terakhir")),
                          DropdownMenuItem(value: 'semua', child: Text("Semua Data")),
                          DropdownMenuItem(value: 'kustom', child: Text("Rentang... (Kustom)")),
                        ],
                        onChanged: (val) {
                          if (val == 'kustom') {
                            _showCustomDatePicker();
                          } else if (val != null) {
                            setState(() {
                              _selectedFilter = val;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Stat Cards
                  Row(
                    children: [
                      _buildStatCard("Rata-rata", filteredData.isEmpty ? "-" : "$avgSys/$avgDia", Colors.orange, Icons.analytics),
                      const SizedBox(width: 12),
                      _buildStatCard("Tertinggi", filteredData.isEmpty ? "-" : "$maxSys/$maxDia", Colors.redAccent, Icons.trending_up),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Chart
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            "Tren Tekanan Darah",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: filteredData.isEmpty
                                ? const Center(child: Text("Tidak ada data di rentang ini"))
                                : LineChart(
                                    LineChartData(
                                      gridData: const FlGridData(show: true, drawVerticalLine: false),
                                      titlesData: FlTitlesData(
                                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                        bottomTitles: AxisTitles(
                                          sideTitles: SideTitles(
                                            showTitles: true,
                                            reservedSize: 22,
                                            getTitlesWidget: (value, meta) {
                                              int index = value.toInt();
                                              if (index >= 0 && index < filteredData.length) {
                                                final tanggal = filteredData[index].tanggal;
                                                // Take MM-dd to be concise if length == 10
                                                String label = tanggal.length >= 10 ? tanggal.substring(5, 10) : tanggal;
                                                return Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey));
                                              }
                                              return const Text('');
                                            },
                                          ),
                                        ),
                                      ),
                                      borderData: FlBorderData(show: false),
                                      minY: 40,
                                      maxY: 200,
                                      lineBarsData: [
                                        LineChartBarData(
                                          spots: systolicSpots,
                                          isCurved: true,
                                          color: Colors.redAccent,
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: true),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.redAccent.withValues(alpha: 0.1),
                                          ),
                                        ),
                                        LineChartBarData(
                                          spots: diastolicSpots,
                                          isCurved: true,
                                          color: Colors.blueAccent,
                                          barWidth: 3,
                                          isStrokeCapRound: true,
                                          dotData: const FlDotData(show: true),
                                          belowBarData: BarAreaData(
                                            show: true,
                                            color: Colors.blueAccent.withValues(alpha: 0.1),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildLegendItem(Colors.redAccent, "Sistolik"),
                              const SizedBox(width: 16),
                              _buildLegendItem(Colors.blueAccent, "Diastolik"),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87)),
      ],
    );
  }
}
