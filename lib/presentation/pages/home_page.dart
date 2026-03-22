import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bp_bloc.dart';
import '../widgets/bp_card.dart';
import 'add_page.dart';
import 'edit_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          "Tekanan Darah",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          _header(),
          Expanded(
            child: BlocBuilder<BPBloc, BPState>(
              builder: (context, state) {
                if (state is BPLoaded) {
                  if (state.data.isEmpty) {
                    return const Center(child: Text("Belum ada data"));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.data.length,
                    itemBuilder: (context, i) {
                      return BPCard(
                          data: state.data[i],
                          onDelete: () {
                            context.read<BPBloc>().add(DeleteBP(i));
                          },
                          onEdit: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => EditPage(
                                  index: i,
                                  data: state.data[i],
                                ),
                              )));
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4CAF50),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddPage()),
          );
        },
      ),
    );
  }

  Widget _header() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4CAF50), Color(0xFF81C784)],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.monitor_heart_outlined, color: Colors.white, size: 40),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kesehatan Anda",
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                "Pantau tekanan darah",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
