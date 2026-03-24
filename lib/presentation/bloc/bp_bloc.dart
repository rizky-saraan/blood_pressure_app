import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/hive_service.dart';
import '../../data/models/blood_pressure_model.dart';

abstract class BPEvent {}
class LoadBP extends BPEvent {}
class LoadMoreBP extends BPEvent {}
class AddBP extends BPEvent {
  final BloodPressureModel data;
  AddBP(this.data);
}
class DeleteBP extends BPEvent {
  final BloodPressureModel data;
  DeleteBP(this.data);
}
class EditBP extends BPEvent {
  final BloodPressureModel oldData;
  final BloodPressureModel newData;
  EditBP(this.oldData, this.newData);
}

abstract class BPState {}
class BPInitial extends BPState {}
class BPLoaded extends BPState {
  final List<BloodPressureModel> data;
  final bool hasMore;
  BPLoaded(this.data, {this.hasMore = false});
}

class BPBloc extends Bloc<BPEvent, BPState> {
  final HiveService service;

  BPBloc(this.service) : super(BPInitial()) {
    on<LoadBP>((event, emit) {
      final items = service.getPaginated(0, 10);
      emit(BPLoaded(items, hasMore: service.box.length > items.length));
    });

    on<LoadMoreBP>((event, emit) {
      if (state is BPLoaded) {
        final currentState = state as BPLoaded;
        if (!currentState.hasMore) return;
        
        final currentData = currentState.data;
        // Fetch 10 next items starting from current array length
        final newItems = service.getPaginated(currentData.length, 10);
        final updatedList = [...currentData, ...newItems];
        emit(BPLoaded(updatedList, hasMore: service.box.length > updatedList.length));
      }
    });

    on<AddBP>((event, emit) async {
      await service.add(event.data);
      int limit = (state is BPLoaded) ? (state as BPLoaded).data.length + 1 : 10;
      if (limit < 10) limit = 10;
      final items = service.getPaginated(0, limit);
      emit(BPLoaded(items, hasMore: service.box.length > items.length));
    });

    on<DeleteBP>((event, emit) async {
      await service.delete(event.data);
      int limit = (state is BPLoaded) ? (state as BPLoaded).data.length : 10;
      if (limit < 10) limit = 10;
      final items = service.getPaginated(0, limit);
      emit(BPLoaded(items, hasMore: service.box.length > items.length));
    });

    on<EditBP>((event, emit) async {
      await service.edit(event.oldData, event.newData);
      int limit = (state is BPLoaded) ? (state as BPLoaded).data.length : 10;
      if (limit < 10) limit = 10;
      final items = service.getPaginated(0, limit);
      emit(BPLoaded(items, hasMore: service.box.length > items.length));
    });
  }
}
