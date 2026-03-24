import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/blood_pressure_model.dart';
import 'bp_bloc.dart';

class ProfileState {
  final List<String> profiles;
  final String activeProfile;
  ProfileState(this.profiles, this.activeProfile);
}

class ProfileCubit extends Cubit<ProfileState> {
  static const _boxName = 'settings_box';
  static const _profilesKey = 'profiles_list';
  static const _activeKey = 'active_profile';

  ProfileCubit() : super(_getInitialState());

  static ProfileState _getInitialState() {
    final box = Hive.box(_boxName);
    final List<String> profiles = box.get(_profilesKey, defaultValue: <String>['Saya'])?.cast<String>() ?? ['Saya'];
    if (profiles.isEmpty) profiles.add('Saya');
    
    String active = box.get(_activeKey, defaultValue: 'Saya');
    if (!profiles.contains(active)) active = profiles.first;

    return ProfileState(profiles, active);
  }

  Future<void> addProfile(String name) async {
    if (name.trim().isEmpty || state.profiles.contains(name.trim())) return;
    
    final newName = name.trim();
    final updatedProfiles = List<String>.from(state.profiles)..add(newName);
    
    final box = Hive.box(_boxName);
    box.put(_profilesKey, updatedProfiles);

    // Prepare box
    if (!Hive.isBoxOpen('bp_box_$newName')) {
      await Hive.openBox<BloodPressureModel>('bp_box_$newName');
    }
    
    emit(ProfileState(updatedProfiles, state.activeProfile));
  }

  Future<void> switchProfile(String name, BPBloc bpBloc) async {
    if (!state.profiles.contains(name) || name == state.activeProfile) return;
    
    final box = Hive.box(_boxName);
    box.put(_activeKey, name);

    if (!Hive.isBoxOpen('bp_box_$name')) {
      await Hive.openBox<BloodPressureModel>('bp_box_$name');
    }

    emit(ProfileState(state.profiles, name));
    bpBloc.add(LoadBP());
  }

  Future<void> deleteProfile(String name, BPBloc bpBloc) async {
    if (!state.profiles.contains(name) || state.profiles.length == 1) return;

    final updatedProfiles = List<String>.from(state.profiles)..remove(name);
    final box = Hive.box(_boxName);
    box.put(_profilesKey, updatedProfiles);

    if (Hive.isBoxOpen('bp_box_$name')) {
      final bpBox = Hive.box<BloodPressureModel>('bp_box_$name');
      await bpBox.clear();
    } else {
      final bpBox = await Hive.openBox<BloodPressureModel>('bp_box_$name');
      await bpBox.clear();
    }

    String active = state.activeProfile;
    if (active == name) {
      active = updatedProfiles.first;
      box.put(_activeKey, active);
      
      if (!Hive.isBoxOpen('bp_box_$active')) {
        await Hive.openBox<BloodPressureModel>('bp_box_$active');
      }
      bpBloc.add(LoadBP());
    }

    emit(ProfileState(updatedProfiles, active));
  }
}
