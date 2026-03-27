import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tankup/blocs/fuel/fuel_state.dart';
import 'package:tankup/models/fuel.dart';
import 'package:tankup/models/vehicle.dart';
import 'package:tankup/services/fuel_price_service.dart';

class FuelCubit extends Cubit<FuelState> {
  FuelCubit() : super(const FuelState());

  void selectFuel(FuelType fuel) {
    emit(state.copyWith(selectedFuel: fuel));
  }

  void setLitres(double litres, double maxCapacity) {
    final clamped = litres.clamp(0.0, maxCapacity);
    // Round to nearest 0.5
    final stepped = (clamped / 0.5).round() * 0.5;
    emit(state.copyWith(litres: stepped.clamp(0.0, maxCapacity)));
  }

  void setFromVND(int vnd, double maxCapacity) {
    if (state.selectedFuel == null) return;
    final price = state.effectivePrice(state.selectedFuel!.id);
    if (price <= 0) return;
    final litres = vnd / price;
    setLitres(litres, maxCapacity);
  }

  void toggleMode() {
    emit(state.copyWith(isLitreMode: !state.isLitreMode));
  }

  void setPreset(FuelPreset preset, Vehicle vehicle) {
    if (state.selectedFuel == null) return;
    final max = vehicle.tankCapacity;
    if (preset.vndAmount case final vnd?) {
      setFromVND(vnd, max);
    } else {
      final price = state.effectivePrice(state.selectedFuel!.id);
      if (price > 0) setLitres(max, max);
    }
  }

  void stepUp(double max) {
    setLitres(state.litres + 0.5, max);
  }

  void stepDown() {
    setLitres(state.litres - 0.5, double.infinity);
  }

  void setBatteryPercent(int percent) {
    // For EV: store percent in litres field (0–100)
    emit(state.copyWith(litres: percent.toDouble().clamp(0, 100)));
  }

  /// Fetch live / cached / hardcoded prices and update state.
  Future<void> loadPrices() async {
    final result = await FuelPriceService.instance.fetchLatestPrices();
    emit(state.copyWith(liveResult: result));
  }

  /// Force a network refresh regardless of cache, resetting to loading state first.
  Future<void> forceRefreshPrices() async {
    emit(state.copyWith(clearLiveResult: true));
    final result = await FuelPriceService.instance.forceRefresh();
    emit(state.copyWith(liveResult: result));
  }

  void reset() {
    emit(state.copyWith(
      clearFuel: true,
      litres: 0.0,
      isLitreMode: true,
      // keep liveResult so prices don't reload on every Screen 1 → 2 trip
    ));
  }
}
