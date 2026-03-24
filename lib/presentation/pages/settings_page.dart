import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/theme_cubit.dart';
import '../bloc/reminder_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          final isDarkMode = themeMode == ThemeMode.dark;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: BlocBuilder<ReminderCubit, ReminderState>(
                  builder: (context, state) {
                    return Column(
                      children: [
                        SwitchListTile(
                          title: const Text("Pengingat Harian", style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: const Text("Pengingat cek tensi"),
                          secondary: const Icon(Icons.alarm),
                          value: state.isEnabled,
                          activeColor: const Color(0xFF4CAF50),
                          onChanged: (value) {
                            context.read<ReminderCubit>().toggleReminder(value);
                          },
                        ),
                        if (state.isEnabled) ...[
                          const Divider(height: 1),
                          for (int i = 0; i < state.times.length; i++)
                            ListTile(
                              leading: const Icon(Icons.access_time),
                              title: Text("Waktu Pengingat ${i + 1}", style: const TextStyle(fontSize: 14)),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    state.times[i].format(context), 
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                                    onPressed: () {
                                      context.read<ReminderCubit>().removeTime(state.times[i]);
                                    },
                                    tooltip: "Hapus Waktu ini",
                                  ),
                                ],
                              ),
                            ),
                          const Divider(height: 1),
                          ListTile(
                            leading: const Icon(Icons.add_circle_outline, color: Color(0xFF4CAF50)),
                            title: const Text("Tambah Waktu Baru", style: TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
                            onTap: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: const TimeOfDay(hour: 8, minute: 0),
                              );
                              if (picked != null) {
                                // ignore: use_build_context_synchronously
                                context.read<ReminderCubit>().addTime(picked);
                              }
                            },
                          ),
                        ]
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                color: Theme.of(context).colorScheme.surface,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: SwitchListTile(
                  title: const Text("Mode Gelap", style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: const Text("Ubah tampilan aplikasi menjadi gelap"),
                  secondary: const Icon(Icons.dark_mode),
                  value: isDarkMode,
                  activeColor: const Color(0xFF4CAF50),
                  onChanged: (value) {
                    context.read<ThemeCubit>().toggleTheme();
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
