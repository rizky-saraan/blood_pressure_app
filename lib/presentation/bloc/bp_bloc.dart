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
      await service.delete(event.data);
      emit(BPLoaded(service.getAll()));
    });

    on<EditBP>((event, emit) async {
      await service.edit(event.oldData, event.newData);
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
  final BloodPressureModel data;
  DeleteBP(this.data);
}

class EditBP extends BPEvent {
  final BloodPressureModel oldData;
  final BloodPressureModel newData;
  EditBP(this.oldData, this.newData);
}

class LoadBP extends BPEvent {}
