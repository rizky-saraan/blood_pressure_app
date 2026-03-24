import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/datasource/hive_service.dart';
import 'data/models/blood_pressure_model.dart';
import 'presentation/bloc/bp_bloc.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/bloc/reminder_cubit.dart';
import 'presentation/bloc/profile_cubit.dart';
import 'presentation/pages/home_page.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BloodPressureModelAdapter());
  
  await Hive.openBox('settings_box');
  
  // Multiple Profile Migration Setup
  final settingsBox = Hive.box('settings_box');
  final List<String> profiles = settingsBox.get('profiles_list', defaultValue: <String>['Saya'])?.cast<String>() ?? ['Saya'];

  // Migrate old 'bp_box'
  if (!Hive.isBoxOpen('bp_box')) await Hive.openBox<BloodPressureModel>('bp_box');
  final oldBox = Hive.box<BloodPressureModel>('bp_box');
  
  if (oldBox.isNotEmpty && !settingsBox.containsKey('migrated_to_profile')) {
    final defaultBox = await Hive.openBox<BloodPressureModel>('bp_box_Saya');
    if (defaultBox.isEmpty) {
      for (var item in oldBox.values) {
        final clonedItem = BloodPressureModel(
          tanggal: item.tanggal,
          jam: item.jam,
          sistolik1: item.sistolik1,
          diastolik1: item.diastolik1,
          sistolik2: item.sistolik2,
          diastolik2: item.diastolik2,
          sistolik3: item.sistolik3,
          diastolik3: item.diastolik3,
          rataSistolik: item.rataSistolik,
          rataDiastolik: item.rataDiastolik,
          nadi: item.nadi,
          kondisi: item.kondisi,
          aktivitas: item.aktivitas,
        );
        await defaultBox.add(clonedItem);
      }
    }
    await oldBox.clear();
    settingsBox.put('migrated_to_profile', true);
  }

  // Ensure all profile boxes are open
  for (String p in profiles) {
    if (!Hive.isBoxOpen('bp_box_$p')) {
      await Hive.openBox<BloodPressureModel>('bp_box_$p');
    }
  }

  await NotificationService().init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BPBloc(HiveService())..add(LoadBP())),
        BlocProvider(create: (_) => ThemeCubit()),
        BlocProvider(create: (_) => ReminderCubit()),
        BlocProvider(create: (_) => ProfileCubit()),
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeMode,
            debugShowCheckedModeBanner: false,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
