import 'package:tankup/models/vehicle.dart';

class VehicleState {
  final int tabIndex; // 0 = motorbike, 1 = car
  final Vehicle? selected;

  const VehicleState({
    this.tabIndex = 0,
    this.selected,
  });

  VehicleState copyWith({
    int? tabIndex,
    Vehicle? selected,
    bool clearSelected = false,
  }) {
    return VehicleState(
      tabIndex: tabIndex ?? this.tabIndex,
      selected: clearSelected ? null : (selected ?? this.selected),
    );
  }
}
