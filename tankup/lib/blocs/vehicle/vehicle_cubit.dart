import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/vehicle/vehicle_state.dart';
import 'package:tankup/models/vehicle.dart';

class VehicleCubit extends Cubit<VehicleState> {
  VehicleCubit() : super(const VehicleState());

  void switchTab(int index) {
    emit(state.copyWith(tabIndex: index, clearSelected: true));
  }

  void selectVehicle(Vehicle vehicle) {
    emit(state.copyWith(selected: vehicle));
  }

  void clearSelection() {
    emit(state.copyWith(clearSelected: true));
  }
}
