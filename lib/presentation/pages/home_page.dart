import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_page.dart';

import '../bloc/bp_bloc.dart';
import '../bloc/profile_cubit.dart';
import '../widgets/bp_card/bp_card.dart';
import 'add_page.dart';
import 'edit_page.dart';
import 'graphic_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
      context.read<BPBloc>().add(LoadMoreBP());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Blood Pressure Tracker",
          style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold),
        ),
        actions: [
          BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return GestureDetector(
                onTap: () => _showProfileDialog(context, state),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF4CAF50)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, size: 16, color: Color(0xFF4CAF50)),
                      const SizedBox(width: 4),
                      Text(
                        state.activeProfile,
                        style: const TextStyle(
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Theme.of(context).appBarTheme.foregroundColor),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _header(),
          _graphicMenu(context),
          Expanded(
            child: BlocBuilder<BPBloc, BPState>(
              builder: (context, state) {
                if (state is BPLoaded) {
                  if (state.data.isEmpty) {
                    return const Center(child: Text("Belum ada data"));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: state.data.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, i) {
                      if (i >= state.data.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      
                      return BPCard(
                          data: state.data[i],
                          onDelete: () {
                            context.read<BPBloc>().add(DeleteBP(state.data[i]));
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
                "Blood Pressure Tracker",
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

  Widget _graphicMenu(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GraphicPage()),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.show_chart, color: Color(0xFF4CAF50)),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Dashboard Grafik",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Lihat tren tekanan darah",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }

  void _showProfileDialog(BuildContext context, ProfileState state) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Pilih Profil Keluarga", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                ...state.profiles.map((profile) {
                  final isActive = profile == state.activeProfile;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isActive ? const Color(0xFF4CAF50) : Colors.grey.shade200,
                      child: Icon(Icons.person, color: isActive ? Colors.white : Colors.grey),
                    ),
                    title: Text(profile, style: TextStyle(fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
                    trailing: isActive 
                        ? const Icon(Icons.check_circle, color: Color(0xFF4CAF50)) 
                        : state.profiles.length > 1 
                            ? IconButton(
                                icon: const Icon(Icons.delete_outline, color: Colors.red),
                                onPressed: () {
                                  context.read<ProfileCubit>().deleteProfile(profile, context.read<BPBloc>());
                                  Navigator.pop(context);
                                },
                              ) 
                            : null,
                    onTap: () {
                      if (!isActive) {
                        context.read<ProfileCubit>().switchProfile(profile, context.read<BPBloc>());
                      }
                      Navigator.pop(context);
                    },
                  );
                }),
                const Divider(),
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFE8F5E9),
                    child: Icon(Icons.add, color: Color(0xFF4CAF50)),
                  ),
                  title: const Text("Tambah Profil Baru", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                  onTap: () {
                    Navigator.pop(context);
                    _showAddProfileDialog(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showAddProfileDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text("Profil Anggota Keluarga Baru", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: "Misal: Ayah",
              border: OutlineInputBorder(),
              isDense: true,
            ),
            textCapitalization: TextCapitalization.words,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF4CAF50)),
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<ProfileCubit>().addProfile(controller.text);
                }
                Navigator.pop(context);
              },
              child: const Text("Simpan", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}
