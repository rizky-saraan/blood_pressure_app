import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/utils/notification_service.dart';

class ReminderState {
  final bool isEnabled;
  final List<TimeOfDay> times;
  ReminderState(this.isEnabled, this.times);
}

class ReminderCubit extends Cubit<ReminderState> {
  static const _boxName = 'settings_box';
  static const _enabledKey = 'isReminderEnabled';
  static const _timesKey = 'reminderTimesList';

  ReminderCubit() : super(_getInitialState());

  static ReminderState _getInitialState() {
    final box = Hive.box(_boxName);
    final isEnabled = box.get(_enabledKey, defaultValue: false);
    final List<String> timesString = box.get(_timesKey, defaultValue: <String>[])?.cast<String>() ?? [];
    
    final times = timesString.map((t) {
      final parts = t.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }).toList();

    // Default to at least one time if empty
    if (times.isEmpty) {
      times.add(const TimeOfDay(hour: 8, minute: 0));
    }

    return ReminderState(isEnabled, times);
  }

  void _saveTimes(List<TimeOfDay> times) {
    final box = Hive.box(_boxName);
    final timesString = times.map((t) => '${t.hour}:${t.minute}').toList();
    box.put(_timesKey, timesString);
  }

  Future<void> toggleReminder(bool value) async {
    final box = Hive.box(_boxName);

    if (value) {
      if (await Permission.notification.request().isGranted) {
        box.put(_enabledKey, true);
        await NotificationService().scheduleDailyNotifications(state.times);
        emit(ReminderState(true, state.times));
      } else {
        box.put(_enabledKey, false);
        emit(ReminderState(false, state.times));
      }
    } else {
      box.put(_enabledKey, false);
      await NotificationService().cancelAllNotifications();
      emit(ReminderState(false, state.times));
    }
  }

  Future<void> addTime(TimeOfDay newTime) async {
    // Avoid duplicates
    if (state.times.any((t) => t.hour == newTime.hour && t.minute == newTime.minute)) return;

    final updatedTimes = List<TimeOfDay>.from(state.times)..add(newTime);
    
    // Sort times by chronology
    updatedTimes.sort((a, b) {
      if (a.hour == b.hour) return a.minute.compareTo(b.minute);
      return a.hour.compareTo(b.hour);
    });

    _saveTimes(updatedTimes);
    emit(ReminderState(state.isEnabled, updatedTimes));

    if (state.isEnabled) {
      await NotificationService().scheduleDailyNotifications(updatedTimes);
    }
  }

  Future<void> removeTime(TimeOfDay timeToRemove) async {
    final updatedTimes = List<TimeOfDay>.from(state.times)..removeWhere((t) => t.hour == timeToRemove.hour && t.minute == timeToRemove.minute);
    
    // Fallback if deleting the last one? Keep at least one, or allow zero?
    // Let's allow 0, but if 0, perhaps turn off the reminder toggle.
    _saveTimes(updatedTimes);
    if (updatedTimes.isEmpty) {
      await toggleReminder(false);
    } else {
      emit(ReminderState(state.isEnabled, updatedTimes));
      if (state.isEnabled) {
        await NotificationService().scheduleDailyNotifications(updatedTimes);
      }
    }
  }
}
