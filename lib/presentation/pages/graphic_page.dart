import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bp_bloc.dart';
import '../../core/utils/excel_service.dart';

class GraphicPage extends StatelessWidget {
  const GraphicPage({super.key});

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
              final state = context.read<BPBloc>().state;
              if (state is BPLoaded && state.data.isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Menyiapkan file Excel..."), duration: Duration(seconds: 1)),
                );
                await ExcelService.exportData(state.data);
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

            List<FlSpot> systolicSpots = [];
            List<FlSpot> diastolicSpots = [];

            for (int i = 0; i < state.data.length; i++) {
              systolicSpots.add(FlSpot(i.toDouble(), state.data[i].rataSistolik.toDouble()));
              diastolicSpots.add(FlSpot(i.toDouble(), state.data[i].rataDiastolik.toDouble()));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: LineChart(
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
                                  if (index >= 0 && index < state.data.length) {
                                    final tanggal = state.data[index].tanggal;
                                    String label = tanggal.length >= 5 ? tanggal.substring(0, 5) : tanggal;
                                    return Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54));
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
                                color: Colors.redAccent.withOpacity(0.1),
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
                                color: Colors.blueAccent.withOpacity(0.1),
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
