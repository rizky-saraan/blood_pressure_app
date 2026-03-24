import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../bloc/reminder_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Pengaturan",
          style: TextStyle(color: Theme.of(context).appBarTheme.foregroundColor, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Theme.of(context).appBarTheme.foregroundColor),
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final isDarkMode = themeMode == ThemeMode.dark;
          final cardColor = Theme.of(context).cardColor;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            children: [
              _buildSectionTitle("TAMPILAN"),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: SwitchListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  title: const Text("Mode Gelap", style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text("Tampilan teduh untuk mata", style: TextStyle(fontSize: 13)),
                  secondary: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blueGrey.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.dark_mode_rounded, color: Colors.blueGrey),
                  ),
                  value: isDarkMode,
                  activeColor: const Color(0xFF4CAF50),
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle("NOTIFIKASI & PENGINGAT"),
              BlocBuilder<ReminderCubit, ReminderState>(
                builder: (context, state) {
                  return Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SwitchListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                          title: const Text("Pengingat Cek Tensi", style: TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: const Text("Aktifkan alarm harian", style: TextStyle(fontSize: 13)),
                          secondary: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(color: const Color(0xFF4CAF50).withValues(alpha: 0.1), shape: BoxShape.circle),
                            child: const Icon(Icons.notifications_active_rounded, color: Color(0xFF4CAF50)),
                          ),
                          value: state.isEnabled,
                          activeColor: const Color(0xFF4CAF50),
                          onChanged: (value) {
                            context.read<ReminderCubit>().toggleReminder(value);
                          },
                        ),
                        if (state.isEnabled) ...[
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Divider(height: 1),
                          ),
                          const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Jadwal Pengingat", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                          ),
                          const SizedBox(height: 8),
                          if (state.times.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                              child: Text("Belum ada jadwal. Silakan tambah.", style: TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic)),
                            ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.times.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                                leading: const Icon(Icons.access_time_rounded, color: Colors.grey, size: 20),
                                title: Text(state.times[i].format(context), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
                                  onPressed: () => context.read<ReminderCubit>().removeTime(state.times[i]),
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16, top: 4),
                            child: InkWell(
                              onTap: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: const TimeOfDay(hour: 8, minute: 0),
                                  builder: (context, child) {
                                    return Theme(
                                      data: Theme.of(context).copyWith(
                                        colorScheme: isDarkMode ? const ColorScheme.dark(primary: Color(0xFF4CAF50)) : const ColorScheme.light(primary: Color(0xFF4CAF50)),
                                      ),
                                      child: child!,
                                    );
                                  },
                                );
                                if (picked != null) {
                                  // ignore: use_build_context_synchronously
                                  context.read<ReminderCubit>().addTime(picked);
                                }
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.add, color: Color(0xFF4CAF50), size: 20),
                                    SizedBox(width: 8),
                                    Text("Tambah Waktu", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              
              _buildSectionTitle("INFORMASI"),
              Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: Colors.blue.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.info_outline_rounded, color: Colors.blue),
                  ),
                  title: const Text("Versi Aplikasi", style: TextStyle(fontWeight: FontWeight.w600)),
                  trailing: const Text("1.0.0", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
