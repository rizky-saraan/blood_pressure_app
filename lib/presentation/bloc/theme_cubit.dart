import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  static const _boxName = 'settings_box';
  static const _themeKey = 'isDarkMode';
  
  ThemeCubit() : super(_getInitialTheme());

  static ThemeMode _getInitialTheme() {
    final box = Hive.box(_boxName);
    final isDark = box.get(_themeKey, defaultValue: false);
    return isDark ? ThemeMode.dark : ThemeMode.light;
  }

  void toggleTheme() {
    final box = Hive.box(_boxName);
    final isDark = state == ThemeMode.dark;
    box.put(_themeKey, !isDark);
    emit(!isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
