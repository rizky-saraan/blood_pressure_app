import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/hive_service.dart';
import '../../data/models/blood_pressure_model.dart';

class AddBP extends BPEvent {
  final BloodPressureModel data;
  AddBP(this.data);
}

class BPBloc extends Bloc<BPEvent, BPState> {
  final HiveService service;

  BPBloc(this.service) : super(BPInitial()) {
    on<LoadBP>((event, emit) {
      emit(BPLoaded(service.getAll()));
    });

    on<AddBP>((event, emit) async {
      await service.add(event.data);
      emit(BPLoaded(service.getAll()));
    });

    on<DeleteBP>((event, emit) async {
      await service.delete(event.index);
      emit(BPLoaded(service.getAll()));
    });

    on<EditBP>((event, emit) async {
      await service.edit(event.index,event.data);
      emit(BPLoaded(service.getAll()));
    });
  }
}

abstract class BPEvent {}

class BPInitial extends BPState {}

class BPLoaded extends BPState {
  final List<BloodPressureModel> data;
  BPLoaded(this.data);
}

abstract class BPState {}

class DeleteBP extends BPEvent {
  final int index;
  DeleteBP(this.index);
}

class EditBP extends BPEvent {
  final int index;
  final BloodPressureModel data;
  EditBP(this.index, this.data);
}

class LoadBP extends BPEvent {}
