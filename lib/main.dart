import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/theme/app_theme.dart';
import 'data/datasource/hive_service.dart';
import 'data/models/blood_pressure_model.dart';
import 'presentation/bloc/bp_bloc.dart';
import 'presentation/bloc/theme_cubit.dart';
import 'presentation/bloc/reminder_cubit.dart';
import 'presentation/pages/home_page.dart';
import 'core/utils/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(BloodPressureModelAdapter());
  await Hive.openBox<BloodPressureModel>('bp_box');
  await Hive.openBox('settings_box');

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
